// block信息
struct __block_impl {
    void *isa; // isa 指针
    int Flags; // block 标记
    int Reserved; // block 截获的自动变量
    void *FuncPtr; // block 调用的方法 为block括号里的实现方式
};

// ==== 没有变量 ==== //
// block 结构体
struct __block__loadBlcok_block_impl_0 {
    struct __block_impl impl;
    struct __block__loadBlcok_block_desc_0* Desc;
    __block__loadBlcok_block_impl_0(void *fp, struct __block__loadBlcok_block_desc_0 *desc, int flags=0) {
        impl.isa = &_NSConcreteStackBlock; // isa 指针
        impl.Flags = flags; // block 标记
        impl.FuncPtr = fp; // block 调用的方法 为block括号里的实现方式
        Desc = desc; // block的描述
    }
};

// block 实现方法
static void __block__loadBlcok_block_func_0(struct __block__loadBlcok_block_impl_0 *__cself) {
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_f6_mvvtz3wx68v0q6kf1b_rlvlm0000gp_T_block_341402_mi_0);
}

// block 描述
static struct __block__loadBlcok_block_desc_0 {
    size_t reserved; // reserved表示保留变量占用的内存大小
    size_t Block_size; // 表示Block结构体(__main_block_impl_0)占用的内存大小
} __block__loadBlcok_block_desc_0_DATA = { 0, sizeof(struct __block__loadBlcok_block_impl_0)};

// block 调用
static void _I_block_loadBlcok(block * self, SEL _cmd) {
    void(*aBlock)(void) = ((void (*)())&__block__loadBlcok_block_impl_0(
                                                                        (void *)__block__loadBlcok_block_func_0,
                                                                        &__block__loadBlcok_block_desc_0_DATA));
    ((void (*)(__block_impl *))((__block_impl *)aBlock)->FuncPtr)((__block_impl *)aBlock);
}


// ==== 捕获局部变量 ==== //
// block 结构体
struct __block__loadBlcok_block_impl_0 {
    struct __block_impl impl;
    struct __block__loadBlcok_block_desc_0* Desc;
    int a; // 捕获的变量 （仅当block使用了 局部变量时会有这个参数 a ）
    __block__loadBlcok_block_impl_0(void *fp, struct __block__loadBlcok_block_desc_0 *desc, int flags=0) : a(_a) {//传入参数值
        impl.isa = &_NSConcreteStackBlock; // isa 指针
        impl.Flags = flags; // block 标记
        impl.FuncPtr = fp; // block 调用的方法 为block括号里的实现方式
        Desc = desc; // block的描述
    }
};

// block 实现方法
static void __block__loadBlcok_block_func_0(struct __block__loadBlcok_block_impl_0 *__cself) {
    int a = __cself->a; // 捕获的变量 （仅当block使用了 局部变量时会有这个参数赋值 a ）
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_f6_mvvtz3wx68v0q6kf1b_rlvlm0000gp_T_block_341402_mi_0);
}

// block 描述
static struct __block__loadBlcok_block_desc_0 {
    size_t reserved; // reserved表示保留变量占用的内存大小
    size_t Block_size; // 表示Block结构体(__main_block_impl_0)占用的内存大小
} __block__loadBlcok_block_desc_0_DATA = { 0, sizeof(struct __block__loadBlcok_block_impl_0)};

// block 调用
static void _I_block_loadBlcok(block * self, SEL _cmd) {
    void(*aBlock)(void) = ((void (*)())&__block__loadBlcok_block_impl_0(
                                                                        (void *)__block__loadBlcok_block_func_0,
                                                                        &__block__loadBlcok_block_desc_0_DATA,
                                                                        a));// 捕获的变量 （仅当block使用了 局部变量时会有这个参数赋值 a ）
    ((void (*)(__block_impl *))((__block_impl *)aBlock)->FuncPtr)((__block_impl *)aBlock);
}




// ==== 捕获alloc变量 静态变量 全局变量==== //
// block 结构体
struct __block__loadBlcok_block_impl_0 {
    struct __block_impl impl;
    struct __block__loadBlcok_block_desc_0* Desc;
    NSObject *obj; // 声明一个指针属性
    __block__loadBlcok_block_impl_0(void *fp, struct __block__loadBlcok_block_desc_0 *desc, NSObject *_obj, int flags=0) : obj(_obj) {//传入指针
        impl.isa = &_NSConcreteStackBlock; // isa 指针
        impl.Flags = flags; // block 标记
        impl.FuncPtr = fp; // block 调用的方法 为block括号里的实现方式
        Desc = desc; // block的描述
    }
};

// block 实现方法
static void __block__loadBlcok_block_func_0(struct __block__loadBlcok_block_impl_0 *__cself) {
    NSObject *obj = __cself->obj; // 获取指针
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_f6_mvvtz3wx68v0q6kf1b_rlvlm0000gp_T_block_341402_mi_0);
}

/*
 enum {
   BLOCK_FIELD_IS_OBJECT = 3, // id, NSObject, __attribute__((NSObject)), block, ...
   BLOCK_FIELD_IS_BLOCK = 7, // a block variable
   BLOCK_FIELD_IS_BYREF = 8, // the on stack structure holding the __block variable
   BLOCK_FIELD_IS_WEAK = 16, // declared __weak
   BLOCK_BYREF_CALLER = 128, // called from byref copy/dispose helpers
 };
 */
// 变量引用方法
static void __block__loadBlcok_block_copy_0(struct __block__loadBlcok_block_impl_0*dst, struct __block__loadBlcok_block_impl_0*src) {_Block_object_assign((void*)&dst->obj, (void*)src->obj, 3/*BLOCK_FIELD_IS_OBJECT*/);}

// 变量释放方法
static void __block__loadBlcok_block_dispose_0(struct __block__loadBlcok_block_impl_0*src) {_Block_object_dispose((void*)src->obj, 3/*BLOCK_FIELD_IS_OBJECT*/);}

// block 描述
static struct __block__loadBlcok_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __block__loadBlcok_block_impl_0*, struct __block__loadBlcok_block_impl_0*);// block 初始化时调用
  void (*dispose)(struct __block__loadBlcok_block_impl_0*); // block 销毁时调用
} __block__loadBlcok_block_desc_0_DATA = { 0, sizeof(struct __block__loadBlcok_block_impl_0), __block__loadBlcok_block_copy_0, __block__loadBlcok_block_dispose_0};

// block 调用
static void _I_block_loadBlcok(block * self, SEL _cmd) {
    NSObject * obj = ((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSObject"), sel_registerName("alloc")), sel_registerName("init"));
    void(*aBlock)(void) = ((void (*)())&__block__loadBlcok_block_impl_0(
                                                                        (void *)__block__loadBlcok_block_func_0,
                                                                        &__block__loadBlcok_block_desc_0_DATA,
                                                                        obj, 570425344)); // 传入指针
    ((void (*)(__block_impl *))((__block_impl *)aBlock)->FuncPtr)((__block_impl *)aBlock);
}
// @end
