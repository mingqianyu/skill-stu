/**
 * ESLint 配置（扁平配置格式）
 * 用于本仓库中 JavaScript/Node 脚本的代码检查。
 * 使用 Node + ES2022 全局、推荐规则，并自定义未使用变量与相等判断等规则。
 */
const js = require('@eslint/js');
const globals = require('globals');

module.exports = [
    js.configs.recommended,
    {
        languageOptions: {
            ecmaVersion: 2022,
            sourceType: 'commonjs',
            globals: {
                ...globals.node,
                ...globals.es2022
            }
        },
        rules: {
            'no-unused-vars': ['error', {
                argsIgnorePattern: '^_',
                varsIgnorePattern: '^_',
                caughtErrorsIgnorePattern: '^_'
            }],
            'no-undef': 'error',
            'eqeqeq': 'warn'
        }
    }
];
