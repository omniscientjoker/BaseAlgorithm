// block信息
struct __block_impl {
    void *isa;// isa 指针
    int Flags;// block 标记
    int Reserved;// block 截获的自动变量
    void *FuncPtr;// block 调用的方法 为block括号里的实现方式
};

// block 结构体
struct __block_block_impl_0 {
    struct __block_impl impl;
    struct __block_block_desc_0* Desc;
    NSObject *obj;// alloc对象
    BlockSimpleCode *self;// 引入全局变量 获取全局变量所在类
    int *staticNum;// 静态局部变量 获取地址
    NSString **staticStr;//静态局部变量 获取地址
    int num; // 局部变量
    NSString *str;// 局部变量
    __block_block_impl_0(void *fp, struct __block_block_desc_0 *desc, NSObject *_obj, BlockSimpleCode *_self, int *_staticNum, NSString **_staticStr, int _num, NSString *_str, int flags=0) : obj(_obj), self(_self), staticNum(_staticNum), staticStr(_staticStr), num(_num), str(_str) {
        impl.isa = &_NSConcreteStackBlock; // isa 指针
        impl.Flags = flags;// block 标记
        impl.FuncPtr = fp;// block 调用的方法 为block括号里的实现方式
        Desc = desc;// block的描述
    }
};

// block 实现方法
static void __block_block_func_0(struct __block_block_impl_0 *__cself) {
    NSObject *obj = __cself->obj; // 局部变量
    BlockSimpleCode *self = __cself->self; // 全局变量
    int *staticNum = __cself->staticNum; // 静态局部变量
    NSString **staticStr = __cself->staticStr; // 静态局部变量
    int num = __cself->num; // 局部变量
    NSString *str = __cself->str; // 局部变量
}

// 变量引用方法
static void __block_block_copy_0(struct __block_block_impl_0*dst, struct __block_block_impl_0*src) {
    _Block_object_assign((void*)&dst->obj,(void*)src->obj, 3/*BLOCK_FIELD_IS_OBJECT*/);
    _Block_object_assign((void*)&dst->self, (void*)src->self, 3/*BLOCK_FIELD_IS_OBJECT*/);
    _Block_object_assign((void*)&dst->staticStr, (void*)src->staticStr, 3/*BLOCK_FIELD_IS_OBJECT*/);
    _Block_object_assign((void*)&dst->str, (void*)src->str, 3/*BLOCK_FIELD_IS_OBJECT*/);
}

// 变量释放方法
static void __block_block_dispose_0(struct __block_block_impl_0*src) {
    _Block_object_dispose((void*)src->obj, 3/*BLOCK_FIELD_IS_OBJECT*/);
    _Block_object_dispose((void*)src->self, 3/*BLOCK_FIELD_IS_OBJECT*/);
    _Block_object_dispose((void*)src->staticStr, 3/*BLOCK_FIELD_IS_OBJECT*/);
    _Block_object_dispose((void*)src->str, 3/*BLOCK_FIELD_IS_OBJECT*/);
}

// block 描述
static struct __block_block_desc_0 {
  size_t reserved;// reserved表示保留变量占用的内存大小
  size_t Block_size;// 表示Block结构体(__main_block_impl_0)占用的内存大小
  void (*copy)(struct __block_block_impl_0*, struct __block_block_impl_0*);// block 初始化时调用
  void (*dispose)(struct __block_block_impl_0*);// block 销毁时调用
} __block_block_desc_0_DATA = { 0, sizeof(struct __block_block_impl_0), __block_block_copy_0, __block_block_dispose_0};

static void _I_BlockSimpleCode_loadBlcok(BlockSimpleCode * self, SEL _cmd) {
    NSObject * obj = ((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSObject"), sel_registerName("alloc")), sel_registerName("init")); // 局部变量 alloc
    static int staticNum = 1;// 静态局部变量 传入值
    static NSString * staticStr = (NSString *)&__NSConstantStringImpl__var_folders_f6_mvvtz3wx68v0q6kf1b_rlvlm0000gp_T_BlockSimpleCode_e6253e_mi_0;// 静态局部变量 传入值
    int num = 1;
    NSString * str = (NSString *)&__NSConstantStringImpl__var_folders_f6_mvvtz3wx68v0q6kf1b_rlvlm0000gp_T_BlockSimpleCode_e6253e_mi_1;
    ((void (*)(id, SEL, int))(void *)objc_msgSend)((id)self, sel_registerName("setPropertyNum:"), 1);// 全局变量 调用 set 方法赋值
    ((void (*)(id, SEL, NSString *))(void *)objc_msgSend)((id)self, sel_registerName("setPropertyStr:"), (NSString *)&__NSConstantStringImpl__var_folders_f6_mvvtz3wx68v0q6kf1b_rlvlm0000gp_T_BlockSimpleCode_e6253e_mi_2);// 全局变量 调用 set 方法赋值
    ((void (*)(id, SEL, NSObject *))(void *)objc_msgSend)((id)self, sel_registerName("setObject:"), ((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSObject"), sel_registerName("alloc")), sel_registerName("init")));// 全局变量 调用 set 方法赋值
    void(*aBlock)(void) = ((void (*)())&__block_block_impl_0(
                                                             (void *)__block_block_func_0,
                                                             &__block_block_desc_0_DATA,
                                                             obj,
                                                             self,
                                                             &staticNum,
                                                             &staticStr,
                                                             num,
                                                             str, 570425344));
    ((void (*)(__block_impl *))((__block_impl *)aBlock)->FuncPtr)((__block_impl *)aBlock);
}

// 引入全局变量 引入变量的 set / get 方法
static NSString * _I_BlockSimpleCode_propertyStr(BlockSimpleCode * self, SEL _cmd) { return (*(NSString **)((char *)self + OBJC_IVAR_$_BlockSimpleCode$_propertyStr)); }
static void _I_BlockSimpleCode_setPropertyStr_(BlockSimpleCode * self, SEL _cmd, NSString *propertyStr) { (*(NSString **)((char *)self + OBJC_IVAR_$_BlockSimpleCode$_propertyStr)) = propertyStr; }

static NSObject * _I_BlockSimpleCode_object(BlockSimpleCode * self, SEL _cmd) { return (*(NSObject **)((char *)self + OBJC_IVAR_$_BlockSimpleCode$_object)); }
static void _I_BlockSimpleCode_setObject_(BlockSimpleCode * self, SEL _cmd, NSObject *object) { (*(NSObject **)((char *)self + OBJC_IVAR_$_BlockSimpleCode$_object)) = object; }

static int _I_BlockSimpleCode_propertyNum(BlockSimpleCode * self, SEL _cmd) { return (*(int *)((char *)self + OBJC_IVAR_$_BlockSimpleCode$_propertyNum)); }
static void _I_BlockSimpleCode_setPropertyNum_(BlockSimpleCode * self, SEL _cmd, int propertyNum) { (*(int *)((char *)self + OBJC_IVAR_$_BlockSimpleCode$_propertyNum)) = propertyNum; }
// @end
