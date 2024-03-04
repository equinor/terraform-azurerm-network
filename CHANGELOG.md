# Changelog

## [3.0.1](https://github.com/equinor/terraform-azurerm-network/compare/v3.0.0...v3.0.1) (2024-03-04)


### Styles

* update variable descriptions ([#64](https://github.com/equinor/terraform-azurerm-network/issues/64)) ([3316b7d](https://github.com/equinor/terraform-azurerm-network/commit/3316b7d16aac03cf859cba4436d9029a8c98d3d3))

## [3.0.0](https://github.com/equinor/terraform-azurerm-network/compare/v2.0.0...v3.0.0) (2023-09-28)


### ⚠ BREAKING CHANGES

* simplify DDoS Protection plan config ([#52](https://github.com/equinor/terraform-azurerm-network/issues/52))
* associate subnet with NSG by default ([#50](https://github.com/equinor/terraform-azurerm-network/issues/50))
* simplify subnet associations ([#47](https://github.com/equinor/terraform-azurerm-network/issues/47))

### Features

* associate subnet with NSG by default ([#50](https://github.com/equinor/terraform-azurerm-network/issues/50)) ([a08c207](https://github.com/equinor/terraform-azurerm-network/commit/a08c207d6ed0b30d776e556e0caf0014779dd132))


### Code Refactoring

* simplify DDoS Protection plan config ([#52](https://github.com/equinor/terraform-azurerm-network/issues/52)) ([ab0b213](https://github.com/equinor/terraform-azurerm-network/commit/ab0b213809e208c4e41601a1f9503e6b1e631af9))
* simplify subnet associations ([#47](https://github.com/equinor/terraform-azurerm-network/issues/47)) ([9eaf248](https://github.com/equinor/terraform-azurerm-network/commit/9eaf248a6fcbfe58e2acc8d5b55952ba92e3cc15))

## [2.0.0](https://github.com/equinor/terraform-azurerm-network/compare/v1.14.0...v2.0.0) (2023-07-27)


### ⚠ BREAKING CHANGES

* move submodules to standalone modules ([#44](https://github.com/equinor/terraform-azurerm-network/issues/44))
* simplify delegation configuration ([#41](https://github.com/equinor/terraform-azurerm-network/issues/41))

### Bug Fixes

* unable to configure DDoS Protection plan ([#45](https://github.com/equinor/terraform-azurerm-network/issues/45)) ([28980df](https://github.com/equinor/terraform-azurerm-network/commit/28980df97dd552cb376484161208611824f0d316))


### Miscellaneous Chores

* move submodules to standalone modules ([#44](https://github.com/equinor/terraform-azurerm-network/issues/44)) ([b8ff56b](https://github.com/equinor/terraform-azurerm-network/commit/b8ff56b0e3bf24287b3cb0475b1df45c377b4fe0))


### Code Refactoring

* simplify delegation configuration ([#41](https://github.com/equinor/terraform-azurerm-network/issues/41)) ([a675118](https://github.com/equinor/terraform-azurerm-network/commit/a675118febdc9b278e4d7f89922b7a9f3e34adf4))

## [1.14.0](https://github.com/equinor/terraform-azurerm-network/compare/v1.13.0...v1.14.0) (2023-06-05)


### Features

* create network interface ([#30](https://github.com/equinor/terraform-azurerm-network/issues/30)) ([3dee697](https://github.com/equinor/terraform-azurerm-network/commit/3dee6975f5f463354e044f2533322d978790ed25))

## [1.13.0](https://github.com/equinor/terraform-azurerm-network/compare/v1.12.0...v1.13.0) (2023-06-02)


### Features

* create public IP address ([#34](https://github.com/equinor/terraform-azurerm-network/issues/34)) ([dddeb73](https://github.com/equinor/terraform-azurerm-network/commit/dddeb734be116418be2efacacea7af2e49f427dc))

## [1.12.0](https://github.com/equinor/terraform-azurerm-network/compare/v1.11.0...v1.12.0) (2023-05-23)


### Features

* **nsg:** create subnet and subnet nat association ([#31](https://github.com/equinor/terraform-azurerm-network/issues/31)) ([ed2bdf0](https://github.com/equinor/terraform-azurerm-network/commit/ed2bdf00d41eccac07ccd5a088e9632ceef7f824))

## [1.11.0](https://github.com/equinor/terraform-azurerm-network/compare/v1.10.0...v1.11.0) (2023-05-15)


### Features

* create NAT gateway ([#28](https://github.com/equinor/terraform-azurerm-network/issues/28)) ([ba42082](https://github.com/equinor/terraform-azurerm-network/commit/ba42082abc8a0980eef89c34cac5f9fb9740a6f7))

## [1.10.0](https://github.com/equinor/terraform-azurerm-network/compare/v1.9.0...v1.10.0) (2023-05-04)


### Features

* **nsg:** create network security group ([#26](https://github.com/equinor/terraform-azurerm-network/issues/26)) ([5f0ad93](https://github.com/equinor/terraform-azurerm-network/commit/5f0ad9359ae15254794840b856816500df5ac9d1))

## [1.9.0](https://github.com/equinor/terraform-azurerm-network/compare/v1.8.0...v1.9.0) (2023-04-27)


### Features

* set default subnet delegation naming ([#21](https://github.com/equinor/terraform-azurerm-network/issues/21)) ([3ef5591](https://github.com/equinor/terraform-azurerm-network/commit/3ef55916eb0c0da5d07548ecec196cc612a943d0))

## [1.8.0](https://github.com/equinor/terraform-azurerm-network/compare/v1.7.0...v1.8.0) (2023-04-20)


### Features

* output address spaces ([#17](https://github.com/equinor/terraform-azurerm-network/issues/17)) ([d2000b4](https://github.com/equinor/terraform-azurerm-network/commit/d2000b407f43824c31dedd4d6c090560176a06d5))

## [1.7.0](https://github.com/equinor/terraform-azurerm-network/compare/v1.6.0...v1.7.0) (2023-02-13)


### Features

* add vm ddos protection plan ([#13](https://github.com/equinor/terraform-azurerm-network/issues/13)) ([57c3cb5](https://github.com/equinor/terraform-azurerm-network/commit/57c3cb5d1a71d357b8f992f2071ee01865bd09a5))
