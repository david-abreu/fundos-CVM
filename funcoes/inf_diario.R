#carregar pacote
if(!require(readr)) install.packages("readr", repos = "http://cran.us.r-project.org")

inf_diario = function(ano,mes){
  
  #formatar a url com os inputs informados
  mes =   formatC(mes,
                  width=2,
                  flag="0")
  
  formato = ".csv"
  url =  paste0("http://dados.cvm.gov.br/dados/FI/DOC/INF_DIARIO/DADOS/inf_diario_fi_",ano,mes,formato)
  
  #baixar dados
  read_delim("http://dados.cvm.gov.br/dados/FI/DOC/INF_DIARIO/DADOS/inf_diario_fi_202105.csv", 
             delim =  ";",
             locale = locale(encoding = "windows-1252"),
             trim_ws = TRUE,
             escape_double = FALSE)
}


