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
      var errors;
      errors = this.lintNode(node, {});
      console.log(errors[0]);
      return console.log(errors[0].lower.variable);
    };

    VariableScopeRule.prototype.lintNode = function(node, upperAssigns, level) {
      var assign, assigns, code, codes, errors, name, upperAssign, _i, _len;
      if (level == null) {
        level = 1;
      }
      errors = [];
      codes = this.nodeCodes(node);
      assigns = this.nodeAssigns(node);
      for (name in assigns) {
        assign = assigns[name];
        assign.scope_level = level;
      }
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
        return assigns[_this.assignName(child)] = child;
      });
      return assigns;
    };

    VariableScopeRule.prototype.assignName = function(assign) {
      return assign.variable.base.value;
    };

    return VariableScopeRule;

  })();

}).call(this);
