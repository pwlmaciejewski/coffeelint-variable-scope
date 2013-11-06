module.exports = class VariableScopeRule
    rule: 
        name: 'variable_scope'
        level : 'warn'
        message : 'You are possibly accidentally overwriting variables'
        description : 'Warns you when you accidentally overwrite outer scope variable'

    lintAST: (node, astApi) ->
        @lintNode node, {}

    assignName: (assign) -> assign.variable.base.value

    lintNode: (node, upperAssigns) ->
        errors = []
        codes = []
        assigns = {}
        node.traverseChildren false, (child) =>
            switch child.constructor.name
                when 'Code' then codes.push child
                when 'Assign' then assigns[@assignName(child)] = child
        for name, upperAssign of upperAssigns
            if @assignName(upperAssign) of assigns then errors.push [upperAssign, assigns[@assignName(upperAssign)]]
            else assigns[@assignName(upperAssign)] = upperAssign
        errors = errors.concat(@lintNode(code.body, assigns)) for code in codes
        errors