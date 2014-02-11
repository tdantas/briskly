#include <briskly_ext.h>

VALUE storage;

VALUE method_briskly_storage_store(VALUE self, VALUE key, VALUE collection) {
  storage = rb_hash_new();
  rb_hash_aset(storage, key, collection);
}

VALUE method_briskly_storage_get(VALUE self, VALUE key) {
  return rb_hash_aref(storage, key);
}
