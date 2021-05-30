#####_____________________ CARREGAR PACOTES______________________________ #####

if(!require(plyr)) install.packages("plyr", repos = "http://cran.us.r-project.org")
if(!require(tidyr)) install.packages("tidyr", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(readr)) install.packages("readr", repos = "http://cran.us.r-project.org")

if (!dir.exists('downloads')) dir.create('downloads')
setwd("downloads")

#####_____________________ BAIXAR DADOS CDA_______________________________ #####


fundosCVM = function(ano,mes){
  
  #formatando a url com os inputs informados
  mes =   formatC(mes, width=2, format="d", flag="0")
  formato = ".zip"
  url =  paste0("http://dados.cvm.gov.br/dados/FI/DOC/CDA/DADOS/cda_fi_",ano,mes,formato)
  nome = paste0(ano,mes,formato)
  
  #baixando e extraindo os arquivos
  download.file(url = url,
                destfile = nome )
  unzip(nome)
  file.remove(nome)
  
  #Juntando todos arquivos em um unico data frame
  df = data.frame()
  
  
  for ( i in  1:length(list.files())){
      dados = read.csv2(list.files()[i],
                        encoding = "latin-1" )
      df = rbind.fill(df,dados)
  }
  
  #removendo arquivos usados
  file.remove(list.files())
  
  #baixando arquivo que contem a classe dos fundos no respectivo ano
  classeFundos = read_delim("http://dados.cvm.gov.br/dados/FI/DOC/EXTRATO/DADOS/extrato_fi_2021.csv", 
                            delim =  ";",
                            locale = locale(encoding = "windows-1252"),
                            trim_ws = TRUE,
                            escape_double = FALSE)
  
  classeFundos = classeFundos %>% 
                  select(CNPJ_FUNDO,CLASSE_ANBIMA) %>% 
                  separate(CLASSE_ANBIMA,
                           into = c('CLASSE_ANB', 'CLASSE_ANB2', 'CLASSE_ANB3',"CLASSE_ANB4"),
                           sep = '-') 
  
  # agregando as classes no df original
  df = left_join(classeFundos,df %>%select(-PK...),
                 by= "CNPJ_FUNDO")
  
  
  return(df)
}




