(function() {
  var VariableScopeRule;

  module.exports = VariableScopeRule = (function() {
    function VariableScopeRule() {}

    VariableScopeRule.prototype.rule = {
      name: 'variable_scope',
      level: 'warn',
      message: 'Outer scope variable overwrite',
      description: 'To never overwrite outer scope variable by accident',
      scopeDiff: 1
    };

    VariableScopeRule.prototype.lintAST = function(node, astApi) {
      var config, error, errors, _i, _len;
      config = astApi.config[this.rule.name];
      errors = this.lintNode(node, {}, this.scopeDiffFilter(config.scopeDiff));
      for (_i = 0, _len = errors.length; _i < _len; _i++) {
        error = errors[_i];
        this.errors.push(astApi.createError({
          context: error.variable,
          lineNumber: error.upper.locationData.first_line + 1,
          lineNumberEnd: error.lower.locationData.first_line + 1
        }));
      }
      return false;
    };

    VariableScopeRule.prototype.scopeDiffFilter = function(diff) {
      return function(lower, upper) {
        return lower.scope_level - upper.scope_level >= diff;
      };
    };

    VariableScopeRule.prototype.lintNode = function(node, upperAssigns, filter, level) {
      var assign, assignArr, assigns, code, codes, errors, name, upper, _i, _j, _len, _len1;
      if (level == null) {
        level = 1;
      }
      filter = filter || function() {
        return true;
      };
      errors = [];
      codes = this.nodeCodes(node);
      assigns = this.nodeAssigns(node);
      for (name in assigns) {
        assignArr = assigns[name];
        for (_i = 0, _len = assignArr.length; _i < _len; _i++) {
          assign = assignArr[_i];
          assign.scope_level = level;
        }
      }
      for (name in upperAssigns) {
        upper = upperAssigns[name];
        if (name in assigns && filter(assigns[name][0], upper)) {
          errors.push({
            variable: name,
            upper: upper,
            lower: assigns[name][0]
          });
        } else {
          assigns[name] = upper;
        }
      }
      for (name in assigns) {
        assignArr = assigns[name];
        if (Array.isArray(assignArr)) {
          assigns[name] = assignArr[assignArr.length - 1];
        }
      }
      for (_j = 0, _len1 = codes.length; _j < _len1; _j++) {
        code = codes[_j];
        errors = errors.concat(this.lintNode(code.body, assigns, filter, level + 1));
      }
      return errors;
    };

    VariableScopeRule.prototype.nodeCodes = function(node) {
      var codes,
        _this = this;
      codes = [];
      node.traverseChildren(false, function(child) {
        if (child.constructor.name === 'Code') {
          return codes.push(child);
        }
      });
      return codes;
    };

    VariableScopeRule.prototype.nodeAssigns = function(node) {
      var assigns,
        _this = this;
      assigns = {};
      node.traverseChildren(false, function(child) {
        if (child.constructor.name !== 'Assign') {
          return;
        }
        if (child.context === 'object') {
          return;
        }
        if (child.variable.properties.length) {
          return;
        }
        if (!assigns[_this.assignName(child)]) {
          assigns[_this.assignName(child)] = [];
        }
        return assigns[_this.assignName(child)].push(child);
      });
      return assigns;
    };

    VariableScopeRule.prototype.assignName = function(assign) {
      return assign.variable.base.value;
    };

    return VariableScopeRule;

  })();

}).call(this);
