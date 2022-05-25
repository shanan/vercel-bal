import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/io;
import ballerina/os;
import ballerina/http;

configurable string database = os:getEnv("PLANETSCALE_DB");
configurable string username = os:getEnv("PLANETSCALE_DB_USERNAME");
configurable string host = os:getEnv("PLANETSCALE_DB_HOST");
configurable string password = os:getEnv("PLANETSCALE_DB_PASSWORD");

final mysql:Client dbClient = check new (host, username, password, database);

service / on new http:Listener(9090) {

    resource function get .() returns record{}[]|error? {
        stream<record {}, error?> rec = dbClient->query(`SELECT * FROM categories`);
        record{}[] arr = [];
        check from var item in rec
            do {
                io:println(item);
                arr.push(item);
            };
        return arr;
    }
}
