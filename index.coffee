module.exports = class VariableScopeRule
    rule: 
        name: 'variable_scope'
        level : 'warn'
        message : 'You accidentally overwrote variables'
        description : 'Warns you when you accidentally overwrite outer scope variable'

    lintAST: (node, astApi) ->
        console.log @lintNode(node, {})[0]

    assignName: (assign) -> assign.variable.base.value

    lintNode: (node, upperAssigns, level = 1) ->
        errors = []
        codes = []
        assigns = {}
        node.traverseChildren false, (child) =>
            switch child.constructor.name
                when 'Code' then codes.push child
                when 'Assign'
                    child.scope_level = level
                    assigns[@assignName(child)] = child
        for name, upperAssign of upperAssigns
            if @assignName(upperAssign) of assigns 
                errors.push
                    variable: name
                    upper: upperAssign
                    lower: assigns[name]
            else assigns[name] = upperAssign
        errors = errors.concat(@lintNode(code.body, assigns, level + 1)) for code in codes
        errors