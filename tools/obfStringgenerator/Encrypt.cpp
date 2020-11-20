#include <iostream>
#include <string>
#include "md5.h"
using namespace std;

string encrypt_by_key(string, string);

int main() {

    string str = "";
    string key = "";
    string fallback = "";
    cout << "Enter string to encrypt: ";
    getline(cin, str);
    cout << "Enter key to encrypt by (such as the world.URL of a certain BYOND server): ";
    getline(cin, key);
    cout << "And finally the fallback/target word (case sensitive!): ";
    getline(cin, fallback);
    cout << "Generated entry for obf_string_list:" << endl;
    cout << "list(\"\", \"" << encrypt_by_key(str, key) << "\", \"" << md5(str) << "\", \"" << fallback << "\",)";
    cin >> key;

    return 0;
}


string encrypt_by_key(string str = "", string key = "")
{
    string result = "";
    key = md5(key);
    for (unsigned int i = 0; i < str.length(); i++) {
        int keyPtr = (i % key.length());
        result = result + static_cast<char>(str[i] + key[keyPtr]);
    }
    return result;
}
