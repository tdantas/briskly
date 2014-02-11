#include <briskly_ext.h>

VALUE Briskly, Storage;

void Init_briskly() {
  printf("Hello Ruby from C!\n");

  Briskly = rb_define_module("Briskly");
  Storage = rb_define_module_under(Briskly, "Storage");
  rb_define_singleton_method(Storage, "store", method_briskly_storage_store, 2);
  rb_define_singleton_method(Storage, "get", method_briskly_storage_get, 1);
}
