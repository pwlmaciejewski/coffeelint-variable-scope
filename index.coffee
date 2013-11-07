module.exports = class VariableScopeRule
    rule: 
        name: 'variable_scope'
        level : 'warn'
        message : 'Outer scope variable overwrite'
        description : 'To never overwrite outer scope variable by accident'
        scopeDiff: 1

    lintAST: (node, astApi) ->
        config = astApi.config[@rule.name]
        errors = @lintNode node, {}, @scopeDiffFilter(config.scopeDiff)
        for error in errors
            @errors.push astApi.createError
                context: error.variable
                lineNumber: error.upper.locationData.first_line + 1
                lineNumberEnd: error.lower.locationData.first_line + 1
        false

    scopeDiffFilter: (diff) ->
        (lower, upper) -> lower.scope_level - upper.scope_level >= diff

    lintNode: (node, upperAssigns, filter, level = 1) ->
        filter = filter or -> true
        errors = []
        codes = @nodeCodes node
        assigns = @nodeAssigns node
        for name, assignArr of assigns
            assign.scope_level = level for assign in assignArr
        for name, upper of upperAssigns
            if name of assigns and filter(assigns[name][0], upper)
                errors.push
                    variable: name
                    upper: upper
                    lower: assigns[name][0]
            else assigns[name] = upper
        for name, assignArr of assigns
            if Array.isArray(assignArr) then assigns[name] = assignArr[assignArr.length - 1]
        errors = errors.concat(@lintNode(code.body, assigns, filter, level + 1)) for code in codes
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