pragma solidity ^0.4.11;
import 'dapple/test.sol';
import 'strings.sol';

contract StringsTest is Test {
	using strings for *;

    function abs(int x) private returns (int) {
        if(x < 0)
            return -x;
        return x;
    }

    function sign(int x) private returns (int) {
        return x/abs(x);
    }

    function assertEq(strings.slice a, strings.slice b) internal {
    	assertEq(a.toString(), b.toString());
    }

    function assertEq(strings.slice a, string b) internal {
        assertEq(a.toString(), b);
    }

	function testSliceToString() {
		var test = "Hello, world!";
		assertEq(test, test.toSlice().toString());
	}

    function testBytes32Len() {
        bytes32 test;
        for(uint i = 0; i <= 32; i++) {
            assertEq(i, test.len());
            test = bytes32((uint(test) / 0x100) | 0x2000000000000000000000000000000000000000000000000000000000000000);
        }
    }

    function testToSliceB32() {
        assertEq(bytes32("foobar").toSliceB32(), "foobar".toSlice());
    }

    function testCopy() {
        var test = "Hello, world!";
        var s1 = test.toSlice();
        var s2 = s1.copy();
        s1._len = 0;
        assertEq(s2._len, bytes(test).length);
    }

    function testLen() {
        assertEq("".toSlice().len(), 0);
        assertEq("Hello, world!".toSlice().len(), 13);
        assertEq("naïve".toSlice().len(), 5);
        assertEq("こんにちは".toSlice().len(), 5);
    }

    function testEmpty() {
        assertTrue("".toSlice().empty());
        assertFalse("x".toSlice().empty());
    }

    function testEquals() {
        assertTrue("".toSlice().equals("".toSlice()));
        assertTrue("foo".toSlice().equals("foo".toSlice()));
        assertFalse("foo".toSlice().equals("bar".toSlice()));
    }

    function testNextRune() {
        var s = "a¡ࠀ𐀡".toSlice();
        assertEq(s.nextRune(), "a");
        assertEq(s, "¡ࠀ𐀡");
        assertEq(s.nextRune(), "¡");
        assertEq(s, "ࠀ𐀡");
        assertEq(s.nextRune(), "ࠀ");
        assertEq(s, "𐀡");
        assertEq(s.nextRune(), "𐀡");
        assertEq(s, "");
        assertEq(s.nextRune(), "");
    }

    function testOrd() {
        assertEq("a".toSlice().ord(), 0x61);
        assertEq("¡".toSlice().ord(), 0xA1);
        assertEq("ࠀ".toSlice().ord(), 0x800);
        assertEq("𐀡".toSlice().ord(), 0x10021);
    }

    function testCompare() {
        assertEq(sign("foobie".toSlice().compare("foobie".toSlice())), 0);
        assertEq(sign("foobie".toSlice().compare("foobie".toSlice())), 0);
        assertEq(sign("foobie".toSlice().compare("foobif".toSlice())), -1);
        assertEq(sign("foobie".toSlice().compare("foobid".toSlice())), 1);
        assertEq(sign("foobie".toSlice().compare("foobies".toSlice())), -1);
        assertEq(sign("foobie".toSlice().compare("foobi".toSlice())), 1);
        assertEq(sign("foobie".toSlice().compare("doobie".toSlice())), 1);
        assertEq(sign("01234567890123456789012345678901".toSlice().compare("012345678901234567890123456789012".toSlice())), -1);
        assertEq(sign("foo.bar".toSlice().split(".".toSlice()).compare("foo".toSlice())), 0);
    }

    function testStartsWith() {
        var s = "foobar".toSlice();
        assertTrue(s.startsWith("foo".toSlice()));
        assertFalse(s.startsWith("oob".toSlice()));
        assertTrue(s.startsWith("".toSlice()));
        assertTrue(s.startsWith(s.copy().rfind("foo".toSlice())));
    }

    function testBeyond() {
        var s = "foobar".toSlice();
        assertEq(s.beyond("foo".toSlice()), "bar");
        assertEq(s, "bar");
        assertEq(s.beyond("foo".toSlice()), "bar");
        assertEq(s.beyond("bar".toSlice()), "");
        assertEq(s, "");
    }

    function testEndsWith() {
        var s = "foobar".toSlice();
        assertTrue(s.endsWith("bar".toSlice()));
        assertFalse(s.endsWith("oba".toSlice()));
        assertTrue(s.endsWith("".toSlice()));
        assertTrue(s.endsWith(s.copy().find("bar".toSlice())));
    }

    function testUntil() {
        var s = "foobar".toSlice();
        assertEq(s.until("bar".toSlice()), "foo");
        assertEq(s, "foo");
        assertEq(s.until("bar".toSlice()), "foo");
        assertEq(s.until("foo".toSlice()), "");
        assertEq(s, "");
    }

    function testFind() {
        assertEq("abracadabra".toSlice().find("abracadabra".toSlice()), "abracadabra");
        assertEq("abracadabra".toSlice().find("bra".toSlice()), "bracadabra");
        assertTrue("abracadabra".toSlice().find("rab".toSlice()).empty());
        assertTrue("12345".toSlice().find("123456".toSlice()).empty());
        assertEq("12345".toSlice().find("".toSlice()), "12345");
        assertEq("12345".toSlice().find("5".toSlice()), "5");
    }

    function testRfind() {
        assertEq("abracadabra".toSlice().rfind("bra".toSlice()), "abracadabra");
        assertEq("abracadabra".toSlice().rfind("cad".toSlice()), "abracad");
        assertTrue("12345".toSlice().rfind("123456".toSlice()).empty());
        assertEq("12345".toSlice().rfind("".toSlice()), "12345");
        assertEq("12345".toSlice().rfind("1".toSlice()), "1");
    }

    function testSplit() {
        var s = "foo->bar->baz".toSlice();
        var delim = "->".toSlice();
        assertEq(s.split(delim), "foo");
        assertEq(s, "bar->baz");
        assertEq(s.split(delim), "bar");
        assertEq(s.split(delim), "baz");
        assertTrue(s.empty());
        assertEq(s.split(delim), "");
        assertEq(".".toSlice().split(".".toSlice()), "");
    }

    function testRsplit() {
        var s = "foo->bar->baz".toSlice();
        var delim = "->".toSlice();
        assertEq(s.rsplit(delim), "baz");
        assertEq(s.rsplit(delim), "bar");
        assertEq(s.rsplit(delim), "foo");
        assertTrue(s.empty());
        assertEq(s.rsplit(delim), "");
    }

    function testCount() {
        assertEq("1121123211234321".toSlice().count("1".toSlice()), 7);
        assertEq("ababababa".toSlice().count("aba".toSlice()), 2);
    }

    function testContains() {
        assertTrue("foobar".toSlice().contains("f".toSlice()));
        assertTrue("foobar".toSlice().contains("o".toSlice()));
        assertTrue("foobar".toSlice().contains("r".toSlice()));
        assertTrue("foobar".toSlice().contains("".toSlice()));
        assertTrue("foobar".toSlice().contains("foobar".toSlice()));
        assertFalse("foobar".toSlice().contains("s".toSlice()));
    }

    function testConcat() {
        assertEq("foo".toSlice().concat("bar".toSlice()), "foobar");
        assertEq("".toSlice().concat("bar".toSlice()), "bar");
        assertEq("foo".toSlice().concat("".toSlice()), "foo");
    }

    function testJoin() {
        var parts = new strings.slice[](4);
        parts[0] = "zero".toSlice();
        parts[1] = "one".toSlice();
        parts[2] = "".toSlice();
        parts[3] = "two".toSlice();

        assertEq(" ".toSlice().join(parts), "zero one  two");
        assertEq("".toSlice().join(parts), "zeroonetwo");

        parts = new strings.slice[](1);
        parts[0] = "zero".toSlice();
        assertEq(" ".toSlice().join(parts), "zero");
    }
}
