struct __Block_byref_blockNum_0 {
  void *__isa;
__Block_byref_blockNum_0 *__forwarding;
 int __flags;
 int __size;
 int blockNum;
};

struct __BlockSimpleCode__loadBlcok_block_impl_0 {
  struct __block_impl impl;
  struct __BlockSimpleCode__loadBlcok_block_desc_0* Desc;
  __Block_byref_blockNum_0 *blockNum; // by ref
  __BlockSimpleCode__loadBlcok_block_impl_0(void *fp, struct __BlockSimpleCode__loadBlcok_block_desc_0 *desc,  __Block_byref_blockNum_0 *_blockNum, int flags=0) : blockNum(_blockNum->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __BlockSimpleCode__loadBlcok_block_func_0(struct __BlockSimpleCode__loadBlcok_block_impl_0 *__cself) {
  __Block_byref_blockNum_0 *blockNum = __cself->blockNum; // bound by ref
}

static void __BlockSimpleCode__loadBlcok_block_copy_0(struct __BlockSimpleCode__loadBlcok_block_impl_0*dst, struct __BlockSimpleCode__loadBlcok_block_impl_0*src) {_Block_object_assign((void*)&dst->str, (void*)src->str, 3/*BLOCK_FIELD_IS_OBJECT*/);_Block_object_assign((void*)&dst->blockNum, (void*)src->blockNum, 8/*BLOCK_FIELD_IS_BYREF*/);}

static void __BlockSimpleCode__loadBlcok_block_dispose_0(struct __BlockSimpleCode__loadBlcok_block_impl_0*src) {_Block_object_dispose((void*)src->str, 3/*BLOCK_FIELD_IS_OBJECT*/);_Block_object_dispose((void*)src->blockNum, 8/*BLOCK_FIELD_IS_BYREF*/);}

static struct __BlockSimpleCode__loadBlcok_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __BlockSimpleCode__loadBlcok_block_impl_0*, struct __BlockSimpleCode__loadBlcok_block_impl_0*);
  void (*dispose)(struct __BlockSimpleCode__loadBlcok_block_impl_0*);
} __BlockSimpleCode__loadBlcok_block_desc_0_DATA = { 0, sizeof(struct __BlockSimpleCode__loadBlcok_block_impl_0), __BlockSimpleCode__loadBlcok_block_copy_0, __BlockSimpleCode__loadBlcok_block_dispose_0};

static void _I_BlockSimpleCode_loadBlcok(BlockSimpleCode * self, SEL _cmd) {
    __attribute__((__blocks__(byref))) __Block_byref_blockNum_0 blockNum = {(void*)0,(__Block_byref_blockNum_0 *)&blockNum, 0, sizeof(__Block_byref_blockNum_0), 1};
    void(*aBlock)(void) = ((void (*)())&__BlockSimpleCode__loadBlcok_block_impl_0((void *)__BlockSimpleCode__loadBlcok_block_func_0, &__BlockSimpleCode__loadBlcok_block_desc_0_DATA, (__Block_byref_blockNum_0 *)&blockNum, 570425344));
    ((void (*)(__block_impl *))((__block_impl *)aBlock)->FuncPtr)((__block_impl *)aBlock);
}
