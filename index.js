(function() {
  var VariableScopeRule;

  module.exports = VariableScopeRule = (function() {
    function VariableScopeRule() {}

    VariableScopeRule.prototype.rule = {
      name: 'variable_scope',
      level: 'warn',
      message: 'You are possibly accidentally overwriting variables',
      description: 'Warns you when you accidentally overwrite outer scope variable'
    };

    VariableScopeRule.prototype.lintAST = function(node, astApi) {
      return this.lintNode(node, {});
    };

    VariableScopeRule.prototype.assignName = function(assign) {
      return assign.variable.base.value;
    };

    VariableScopeRule.prototype.lintNode = function(node, upperAssigns) {
      var assigns, code, codes, errors, name, upperAssign, _i, _len,
        _this = this;
      errors = [];
      codes = [];
      assigns = {};
      node.traverseChildren(false, function(child) {
        switch (child.constructor.name) {
          case 'Code':
            return codes.push(child);
          case 'Assign':
            return assigns[_this.assignName(child)] = child;
        }
      });
      for (name in upperAssigns) {
        upperAssign = upperAssigns[name];
        if (this.assignName(upperAssign) in assigns) {
          errors.push([upperAssign, assigns[this.assignName(upperAssign)]]);
        } else {
          assigns[this.assignName(upperAssign)] = upperAssign;
        }
      }
      for (_i = 0, _len = codes.length; _i < _len; _i++) {
        code = codes[_i];
        errors = errors.concat(this.lintNode(code.body, assigns));
      }
      return errors;
    };

    return VariableScopeRule;

  })();

}).call(this);
