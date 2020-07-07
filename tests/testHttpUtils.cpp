#define BOOST_TEST_MODULE testHttpUtils
#include <boost/test/included/unit_test.hpp>
#include "../src/HttpUtils.h"

// init_unit_test();
//BOOST_AUTO_TEST_SUITE(testsHttpUtils)

BOOST_AUTO_TEST_CASE(testA) {
    beast::string_view mimeType = HttpUtils::getMimeType("test.html");
    BOOST_CHECK_EQUAL(mimeType,"text/html");
}

//BOOST_AUTO_TEST_SUITE_END()