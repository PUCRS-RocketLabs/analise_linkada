Rode o simulacao_prop_s_OF_cte_octavio.m

que ele deve rodar e automaticamente vai rodar o desempenho_foguete_balistico_octavio.m   (essa versao octave nao usa o atmosisa pra calculo de arrasto, coloquei o rho constante como 1.0 lá de placeholder)

O simulacao_prop_s_OF_cte é pra simular um motor híbrido, usando a metodologia da taxa de regressão pela vazão de oxidante, não lembro exatamente a referencia que usei, mas é a padrãozona
Ele tem varias simplificações.. pressão na camara constante, vazão massica de oxidante constante, injetores super simplificados etc

o desempenho_foguete_balistico é pra cálculo de desempenho com o mínimo possível de informação sobre o foguete
Básicamente só as massas, o diâmetro e a curva de empuxo ele já estima, muito rápido e bom pra estimar capacidade de motor

os outputs são apogeu, max mach, max arrasto, impulso específico de voo (calculado pelo apogeu) entre outros
