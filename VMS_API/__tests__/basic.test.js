const path = require('path');
const rootPath = process.cwd();
const dateConvertPath = path.join(rootPath, 'src', 'utils', 'dateConvert');
const { valiDate } = require(dateConvertPath);

describe('validate date', () => {
  it('date format is correct', () => {
    const res = valiDate('2021-02-05');
    expect(res).toBe(true);
  });
});

describe('validate date', () => {
  it('date format is correct', () => {
    const res = valiDate('2021/02/05');
    expect(res).toBe(true);
  });
});

describe('validate date', () => {
  it('date format is correct', () => {
    const res = valiDate('2021/02/05555');
    expect(res).toBe(false);
  });
});

describe('validate date', () => {
  it('date format is correct', () => {
    const res = valiDate('2021-02-15T00:00:00.000Z');
    expect(res).toBe(true);
  });
});

describe('validate date', () => {
  it('date format is correct', () => {
    const res = valiDate('22021-02-');
    expect(res).toBe(false);
  });
});

describe('validate date', () => {
  it('date format is correct', () => {
    const res = valiDate('02-');
    expect(res).toBe(false);
  });
});
