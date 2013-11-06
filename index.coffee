module.exports = class VariableScopeRule
    rule: 
        name: 'variable_scope'
        level : 'warn'
        message : 'You accidentally overwrote variables'
        description : 'Warns you when you accidentally overwrite outer scope variable'

    lintAST: (node, astApi) ->
        errors = @lintNode(node, {})
        console.log errors[0]
        console.log errors[0].lower.variable

    lintNode: (node, upperAssigns, level = 1) ->
        errors = []
        codes = @nodeCodes node
        assigns = @nodeAssigns node
        assign.scope_level = level for name, assign of assigns
        for name, upperAssign of upperAssigns
            if @assignName(upperAssign) of assigns 
                errors.push
                    variable: name
                    upper: upperAssign
                    lower: assigns[name]
            else assigns[name] = upperAssign
        errors = errors.concat(@lintNode(code.body, assigns, level + 1)) for code in codes
        errors

    nodeCodes: (node) ->
        codes = []
        node.traverseChildren false, (child) =>
            if child.constructor.name is 'Code' then codes.push child
        codes

    nodeAssigns: (node) ->
        assigns = {}
        node.traverseChildren false, (child) =>
            if child.constructor.name isnt 'Assign' then return
            if child.context is 'object' then return
            if child.variable.properties.length then return
            assigns[@assignName(child)] = child
        assigns

    assignName: (assign) -> assign.variable.base.value