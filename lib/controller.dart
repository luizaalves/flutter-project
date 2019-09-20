import 'dart:async';
import 'dart:convert';
import 'package:controller/model.dart';

import 'package:http/http.dart' as http;

class ControllerService {

  http.Client client = http.Client();
  static String cookies;


  Future<bool> verificarAcesso() async {  
    final response = await client.get("https://trial.msitec.com.br/sessao/amionline/",headers: headers());    
    if(response.headers['set-cookie']!=null){
      ControllerService.cookies = response.headers['set-cookie'];
    }
    return response.body=='true';
  }

  Future<bool> autenticar(String usuario,String senha) async {
    final response = await client.post("https://trial.msitec.com.br/sessao/reautenticar/",headers: headers(),body:jsonEncode({'usuario':{'usuario':usuario,'senha':senha}}));    
    if(response.headers['set-cookie']!=null){
      ControllerService.cookies = response.headers['set-cookie'];
    }
    return !(jsonDecode(response.body)['autenticar'] as bool);
  }

  Map<String,String> headers(){
     return {
      'Content-type': 'application/json', 
      'Accept': 'application/json',
      'Cookie': ControllerService.cookies
    };
  }

  Future<List<Lancamento>> contasReceber(int page,int qtd) async {    
    var response = await client.post("https://trial.msitec.com.br/financeiro/lancamentos/receber/vencidos/",headers: headers(),body: jsonEncode({"page":page,"itemsPerPage":qtd,"column":"dataVencimento","order":"desc"}));            
    var list = jsonDecode(response.body)['rows'] as List;
    if(list==null)return [];
    return list.map((i)=>Lancamento.fromJson(i)).toList();
  }

  Future<List<Lancamento>> contasPagar(int page,int qtd) async {
    var response = await client.post("https://trial.msitec.com.br/financeiro/lancamentos/pagar/vencidos/",headers: headers(),body: jsonEncode({"page":page,"itemsPerPage":qtd,"column":"dataVencimento","order":"desc"}));
    var list = jsonDecode(response.body)['rows'] as List;
    if(list==null)return [];
    return list.map((i)=>Lancamento.fromJson(i)).toList();
  }
}