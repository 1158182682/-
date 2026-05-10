class DefaultChecklistTemplates {
  static const List<Map<String, String>> overseasPreparationChecklist = [
    // 证件类
    {'category': '证件类', 'title': '护照（有效期 6 个月以上）'},
    {'category': '证件类', 'title': '签证/入境许可'},
    {'category': '证件类', 'title': '身份证'},
    {'category': '证件类', 'title': '机票/行程单'},
    {'category': '证件类', 'title': '酒店确认单'},
    {'category': '证件类', 'title': '旅行保险单'},
    {'category': '证件类', 'title': '驾照及国际驾照翻译件'},
    {'category': '证件类', 'title': '证件复印件与电子备份'},

    // 支付类
    {'category': '支付类', 'title': '双币信用卡'},
    {'category': '支付类', 'title': '借记卡/储蓄卡'},
    {'category': '支付类', 'title': '少量当地现金'},
    {'category': '支付类', 'title': '外币兑换凭证'},
    {'category': '支付类', 'title': '支付 App 国际版设置检查'},
    {'category': '支付类', 'title': '银行卡境外支付开通'},
    {'category': '支付类', 'title': '银行紧急联系电话记录'},

    // 电子类
    {'category': '电子类', 'title': '手机'},
    {'category': '电子类', 'title': '充电器'},
    {'category': '电子类', 'title': '充电宝（符合航空规定）'},
    {'category': '电子类', 'title': '转换插头'},
    {'category': '电子类', 'title': '多口排插'},
    {'category': '电子类', 'title': '相机/运动相机'},
    {'category': '电子类', 'title': '相机电池与存储卡'},
    {'category': '电子类', 'title': '耳机'},

    // 衣物类
    {'category': '衣物类', 'title': '上衣（按天数准备）'},
    {'category': '衣物类', 'title': '裤子/裙子'},
    {'category': '衣物类', 'title': '内衣裤'},
    {'category': '衣物类', 'title': '睡衣'},
    {'category': '衣物类', 'title': '外套/防风衣'},
    {'category': '衣物类', 'title': '舒适步行鞋'},
    {'category': '衣物类', 'title': '拖鞋'},
    {'category': '衣物类', 'title': '雨具（雨伞/雨衣）'},

    // 药品类
    {'category': '药品类', 'title': '常用处方药'},
    {'category': '药品类', 'title': '感冒药'},
    {'category': '药品类', 'title': '肠胃药'},
    {'category': '药品类', 'title': '止痛药'},
    {'category': '药品类', 'title': '创可贴/纱布'},
    {'category': '药品类', 'title': '消毒用品'},
    {'category': '药品类', 'title': '过敏药'},

    // 洗护类
    {'category': '洗护类', 'title': '牙刷牙膏'},
    {'category': '洗护类', 'title': '洗面奶'},
    {'category': '洗护类', 'title': '洗发/护发用品'},
    {'category': '洗护类', 'title': '沐浴用品'},
    {'category': '洗护类', 'title': '防晒霜'},
    {'category': '洗护类', 'title': '护肤品'},
    {'category': '洗护类', 'title': '剃须用品/化妆用品'},
    {'category': '洗护类', 'title': '毛巾'},

    // 通讯类
    {'category': '通讯类', 'title': '护照信息电子备份'},
    {'category': '通讯类', 'title': '目的地 eSIM/SIM 卡'},
    {'category': '通讯类', 'title': '国际漫游开通确认'},
    {'category': '通讯类', 'title': '离线地图下载'},
    {'category': '通讯类', 'title': '翻译 App 离线包下载'},
    {'category': '通讯类', 'title': '紧急联系人名单'},
    {'category': '通讯类', 'title': '重要地址与电话离线保存'},

    // 出发前事项
    {'category': '出发前事项', 'title': '确认航班时间与值机'},
    {'category': '出发前事项', 'title': '检查证件有效期'},
    {'category': '出发前事项', 'title': '确认酒店入住信息'},
    {'category': '出发前事项', 'title': '购买/确认旅行保险'},
    {'category': '出发前事项', 'title': '家中水电燃气检查'},
    {'category': '出发前事项', 'title': '告知家人行程安排'},
    {'category': '出发前事项', 'title': '设置银行卡交易提醒'},
    {'category': '出发前事项', 'title': '重要文件云端与本地双备份'},
  ];
}


class DefaultTravelNotesTemplates {
  static const List<Map<String, String>> defaultTravelNotes = [
    {'type': '安全', 'title': '夜间尽量结伴出行', 'content': '避免深夜独自前往陌生区域，保管好随身物品。'},
    {'type': '交通', 'title': '提前确认机场/车站交通', 'content': '了解首末班时间与购票方式，预留至少30分钟缓冲。'},
    {'type': '支付', 'title': '准备多种支付方式', 'content': '现金、信用卡与移动支付同时准备，防止单一方式失效。'},
    {'type': '风俗', 'title': '尊重当地礼仪与禁忌', 'content': '进入宗教场所注意着装与拍照限制。'},
    {'type': '入境', 'title': '入境材料放在易取位置', 'content': '护照、签证、返程机票和酒店订单建议纸质+电子双备份。'},
    {'type': '其他', 'title': '紧急联系人信息离线保存', 'content': '在无网情况下也能查看家人、使馆和保险电话。'},
  ];
}
