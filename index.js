(function() {
  var VariableScopeRule;

  module.exports = VariableScopeRule = (function() {
    function VariableScopeRule() {}

    VariableScopeRule.prototype.rule = {
      name: 'variable_scope',
      level: 'warn',
      message: 'You accidentally overwrote variables',
      description: 'Warns you when you accidentally overwrite outer scope variable'
    };

    VariableScopeRule.prototype.lintAST = function(node, astApi) {
      return console.log(this.lintNode(node, {})[0]);
    };

    VariableScopeRule.prototype.assignName = function(assign) {
      return assign.variable.base.value;
    };

    VariableScopeRule.prototype.lintNode = function(node, upperAssigns, level) {
      var assigns, code, codes, errors, name, upperAssign, _i, _len,
        _this = this;
      if (level == null) {
        level = 1;
      }
      errors = [];
      codes = [];
      assigns = {};
      node.traverseChildren(false, function(child) {
        switch (child.constructor.name) {
          case 'Code':
            return codes.push(child);
          case 'Assign':
            child.scope_level = level;
            return assigns[_this.assignName(child)] = child;
        }
      });
      for (name in upperAssigns) {
        upperAssign = upperAssigns[name];
        if (this.assignName(upperAssign) in assigns) {
          errors.push({
            variable: name,
            upper: upperAssign,
            lower: assigns[name]
          });
        } else {
          assigns[name] = upperAssign;
        }
      }
      for (_i = 0, _len = codes.length; _i < _len; _i++) {
        code = codes[_i];
        errors = errors.concat(this.lintNode(code.body, assigns, level + 1));
      }
      return errors;
    };

    return VariableScopeRule;

  })();

}).call(this);
