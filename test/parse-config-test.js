const assert = require('node:assert/strict');
const { execFileSync } = require('node:child_process');
const path = require('node:path');
const { test } = require('node:test');
const config = require('../conf/config.json');

test('devtools download filename preserves the dotted version', () => {
    const url = execFileSync(process.execPath, [
        path.join(__dirname, '../tools/parse-config.js'), '--get-devtools-url',
    ], { encoding: 'utf8' }).trim();
    assert.equal(path.posix.basename(new URL(url).pathname),
        `wechat_devtools_${config.devtools.version}_win32_x64.exe`);
});
