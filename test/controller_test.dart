import 'package:controller/controller.dart';
import 'package:test/test.dart';
import 'package:controller/model.dart';

void main(){
  group('ControllerService',(){
    ControllerService service;
    String password;
    setUp((){
      service = ControllerService();
      var date = DateTime.now();
      String soma = (date.day+date.month).toString();
      password = "\$pass+rt@$soma";
    });    
        
    test("deveRetornarFalseParaUsuarioNaoLogado", () async {    
      bool autenticado = await service.verificarAcesso();
      expect(autenticado, false);
    });
    test("deveRetornarTrueParaUsuarioLogado", () async {       
      await service.autenticar("root", password);  
      bool autenticado = await service.verificarAcesso();
      expect(autenticado, true);
    });
    test("deveAutenticarNoController", () async {
      bool autenticado = await service.autenticar("root", password);
      expect(autenticado, true);
    });

    test("deveBuscarContasPagar", () async {        
      await service.autenticar("root", password);           
      List<Lancamento> lancamentos = await service.contasPagar(0,30);
      expect(lancamentos.length, 30);      
    });

    test("deveBuscarContasReceber", () async {            
      await service.autenticar("root", password);           
      List<Lancamento> lancamentos = await service.contasReceber(0,10);
      expect(lancamentos.length, 10);   
    });

    tearDown((){
      service = null;
    });
  });
}