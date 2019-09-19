
class Lancamento {
  final int id;
  final Colaborador colaborador;
  final String conta;
  final double valor;

  Lancamento({this.id, this.colaborador,this.conta,this.valor});

  factory Lancamento.fromJson(Map<String, dynamic> json) {
    return Lancamento(
      id: json['id'],
      colaborador: Colaborador.fromJson(json['colaborador']),
      conta:json['conta'],
      valor:json['valor']
    );
  }
}

class Colaborador{
  final int id;
  final String razaoSocial;

  Colaborador({this.id,this.razaoSocial});

  factory Colaborador.fromJson(Map<String,dynamic> json){
    return Colaborador(
      id:json['id'],
      razaoSocial:json['razaoSocial']
    );
  }
}

