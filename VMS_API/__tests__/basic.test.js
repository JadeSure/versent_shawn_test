const path = require('path');
const rootPath = path.resolve(__dirname, '../..');
const dateConvertPath = path.join(rootPath, 'src', 'utils', 'dateConvert');

const { valiDate } = require(dateConvertPath);

describe('validate date', () => {
  it('date format is correct', () => {
    const res = valiDate('2021-02-05');
    expect(res).toBe(true);
  });
});
