module.exports = class VariableScopeRule
    rule: 
        name: 'variable_scope'
        level : 'warn'
        message : 'You accidentally overwrote variables'
        description : 'Warns you when you accidentally overwrite outer scope variable'

    lintAST: (node, astApi) ->
        errors = @lintNode(node, {})
        console.log errors[3]

    lintNode: (node, upperAssigns, level = 1) ->
        errors = []
        codes = @nodeCodes node
        assigns = @nodeAssigns node
        for name, assignArr of assigns
            assign.scope_level = level for assign in assignArr
        for name, upperAssign of upperAssigns
            if name of assigns 
                errors.push
                    variable: name
                    upper: upperAssign
                    lower: assigns[name][0]
            else assigns[name] = upperAssign
        for name, assignArr of assigns
            if Array.isArray(assignArr) then assigns[name] = assignArr[assignArr.length - 1]
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
            unless assigns[@assignName(child)] then assigns[@assignName(child)] = []
            assigns[@assignName(child)].push child
        assigns

    assignName: (assign) -> assign.variable.base.value