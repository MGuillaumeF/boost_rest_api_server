#define BOOST_TEST_MODULE testHttpUtils
#include <boost/test/included/unit_test.hpp>
#include "HttpUtils.h"

// init_unit_test();

BOOST_AUTO_TEST_CASE(testA) {
    beast::string_view mimeType = HttpUtils::getMimeType("test.hml");
    BOOST_CHECK_EQUAL(mimeType,"text/html");
}