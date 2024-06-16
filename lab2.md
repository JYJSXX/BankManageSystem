### 实体及其属性

1. **银行信息 (Bank)**
    - `BankID` (主键)
    - `BName`
    - `BAddress`
    - `Bmail`
    - `BTel`
2. **客户信息 (Customer)**
    - `CustomerID` (主键)
    - `CName`
    - `CAddress`
    - `CTel`
    - `Cmail`
3. **账户信息 (Account)**
    - `AccountID` (主键)
    - `AccountType`
    - `Balance`
    - `CustomerID` (外键，引用 Customer)
    - `BankID` (外键，引用 Bank)
4. **贷款信息 (Loan)**
    - `LoanID` (主键)
    - `Amount`
    - `InterestRate`
    - `LoanDate`
    - `Request Date`
    - `Status`
    - `AccountID` (外键，引用 Customer)
    - `Employee ID` (外键，引用 Employee)
    - `BankID` (外键，引用 Bank)
5. **银行部门信息 (Department)**
    - `DepartmentID` (主键)
    - `DName`
    - `BankID` (外键，引用 Bank)
6. **员工信息 (Employee)**
    - `EmployeeID` (主键)
    - `EName`
    - `Email`
    - `Salary`
    - `DepartmentID` (外键，引用 Department)

### 实体关系

- 一个银行有多个客户和多个账户。
- 一个客户可以有多个账户。
- 一个账户可以有多个贷款
- 一个银行有多个部门。
- 一个部门有多个员工。
- 每个贷款和账户都关联到一个特定的银行和客户。

###  ER 图见附件

[DataBase_ER_Graph.pdf](DataBase_ER_Graph.pdf) 

### Json 格式
> Sign in
```json
{
   "type": "login",
   "name": "name",
   "password": "password"
}

```

> Sign up

```json
{
   "type": "register",
   "name": "name",
   "password": "password",
   "email": "email",
   "phone": "phone"
}
```

> Get all banks

```json
{
   "type": "getBankList"
}
```

> Loan Status 

```
-2 拒绝
-1 未确认
0  确认，未还
1  确认，已还
```

