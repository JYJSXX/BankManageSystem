Map<String, String> bankAccountTypesWithDescriptions = {
  'Checking Account': '用于日常交易，如存款、提款和支付账单，通常提供支票和借记卡功能。',
  'Savings Account': '用于存储资金，通常提供利息，但限制每月的提款次数。',
  'Money Market Account': '结合了支票账户和储蓄账户的特性，通常提供更高的利率，但要求更高的最低余额。',
  'Certificate of Deposit (CD)': '一种定期存款账户，在特定时间内提供固定利息，提早提款可能会有罚金。',
  'Individual Retirement Account (IRA)': '用于退休储蓄，具有税收优惠，包括传统IRA和罗斯IRA。',
  'Brokerage Account': '用于买卖股票、债券和其他证券，通常由经纪公司提供。',
  'Joint Account': '由两个或更多人共同持有，通常用于夫妻或家庭成员之间。',
  'Trust Account': '由受托人管理的账户，用于为受益人（如家人或慈善机构）保存和分配资产。',
  'Student Account': '为学生设计的账户，通常提供免手续费和其他优惠条件。',
  'Business Account': '用于公司或商业用途，支持处理大量交易和企业相关服务。',
  'Custodial Account': '为未成年人开设的账户，由监护人或托管人管理，直到孩子达到法定年龄。'
};

List<String> commonBankAccountTypes = [
  // 活期账户：用于日常交易，如存款、提款和支付账单，通常提供支票和借记卡功能。
  'Checking Account',

  // 储蓄账户：用于存储资金，通常提供利息，但限制每月的提款次数。
  'Savings Account',

  // 货币市场账户：结合了支票账户和储蓄账户的特性，通常提供更高的利率，但要求更高的最低余额。
  'Money Market Account',

  // 存款证 (CD)：一种定期存款账户，在特定时间内提供固定利息，提早提款可能会有罚金。
  'Certificate of Deposit (CD)',

  // 个人退休账户 (IRA)：用于退休储蓄，具有税收优惠，包括传统IRA和罗斯IRA。
  'Individual Retirement Account (IRA)',

  // 经纪账户：用于买卖股票、债券和其他证券，通常由经纪公司提供。
  'Brokerage Account',

  // 联合账户：由两个或更多人共同持有，通常用于夫妻或家庭成员之间。
  'Joint Account',

  // 信托账户：由受托人管理的账户，用于为受益人（如家人或慈善机构）保存和分配资产。
  'Trust Account',

  // 学生账户：为学生设计的账户，通常提供免手续费和其他优惠条件。
  'Student Account',

  // 企业账户：用于公司或商业用途，支持处理大量交易和企业相关服务。
  'Business Account',

  // 托管账户：为未成年人开设的账户，由监护人或托管人管理，直到孩子达到法定年龄。
  'Custodial Account'
];