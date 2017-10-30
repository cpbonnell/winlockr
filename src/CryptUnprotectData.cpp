#include <Rcpp.h>
#include <stdio.h>


// Some fixes to make the code play nicely with Windows.h ...
#undef Realloc
#undef Free

// Windows specific includes...
//#pragma comment(lib, "crypt32.lib")

#include <windows.h>
#include <wincrypt.h>
using namespace Rcpp;




//' A wrapper for the Windows DPAPI function CryptUnprotectData()
//'
//' This function is intended to be an internal helper file for the package.
//' Both parameters are currently necessary, and bust be between 1 and 256 bytes
//' in length. The salt should be the one used to encrypt pwd in the first place
//'
//' @param pwd The raw bytes of the encrypted password
//' @param salt The raw bytes of the salt used when the password was encrypted
// [[Rcpp::export]]
List CryptUnprotectData(Rcpp::RawVector pwd, Rcpp::RawVector salt){

  const int MAX_BYTES = 256;

  if(pwd.size() > MAX_BYTES || salt.size() > MAX_BYTES){
    return List::create(Named("ERROR") = "Parameters too long.\n");
  }

  int pwd_len = 0;
  int salt_len = 0;
  BYTE pwd_buffer[MAX_BYTES];
  BYTE salt_buffer[MAX_BYTES];

  // Copy the input data into buffers and appropriate Windows types
  pwd_len = pwd.size();
  salt_len = salt.size();

  for(int i = 0; i < pwd.size(); i++){
    pwd_buffer[i] = pwd[i];
  }

  for(int i = 0; i < salt.size(); i++){
    salt_buffer[i] = salt[i];
  }

  // Point some windows structures at the buffers
  DATA_BLOB pwd_blob;
  DATA_BLOB salt_blob;
  DATA_BLOB unencrypted_blob;

  pwd_blob.cbData = pwd_len;
  pwd_blob.pbData = pwd_buffer;

  salt_blob.cbData = salt_len;
  salt_blob.pbData = salt_buffer;


  // Now call the OS function to encrypt the data
  CryptUnprotectData(
    &pwd_blob,
    NULL,
    &salt_blob,
    NULL, NULL, 0,
    &unencrypted_blob
  );


  // Move the encrypted data to a structure that can be returned
  Rcpp::RawVector unprot;

  for(unsigned int i = 0; i < unencrypted_blob.cbData; i++){
    unprot.push_back(unencrypted_blob.pbData[i]);
  }

  // Clean up memory (opposite order from CryptProtectData...)
  SecureZeroMemory(unencrypted_blob.pbData, MAX_BYTES);
  LocalFree(unencrypted_blob.pbData);



  return List::create(
    Named("success") = "TRUE",
    Named("unprotected_pwd") = unprot
  );
}


