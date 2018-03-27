pragma solidity ^0.4.21;

import "ds-test/test.sol";

import "./SolidityStringutils.sol";

contract SolidityStringutilsTest is DSTest {
    SolidityStringutils stringutils;

    function setUp() public {
        stringutils = new SolidityStringutils();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
