// Run with: ELECTRON_RUN_AS_NODE=1 ./electron/electron test/swc-test.js
const assert = require('node:assert/strict');
const path = require('node:path');
const vm = require('node:vm');
const swc = require(path.join(__dirname, '../resources/app.asar/node_modules/@swc/core'));

const { code } = swc.transformSync('const answer: number = 42; module.exports = answer;', {
    filename: 'native-binding-test.ts',
    jsc: { parser: { syntax: 'typescript' } },
});
const moduleResult = { exports: {} };
vm.runInNewContext(code, { module: moduleResult });
assert.equal(moduleResult.exports, 42);
console.log(`SWC ${swc.version} native binding test passed`);
