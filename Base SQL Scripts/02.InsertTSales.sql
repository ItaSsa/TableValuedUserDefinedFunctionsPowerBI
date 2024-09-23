USE COMMERCIAL_DB
GO


-- Insert values

TRUNCATE TABLE T_SALES

INSERT INTO T_SALES
(
    DOCUMENT_NUMBER	 
  , COMPANY_CODE     
  , CUSTOMER_CODE    
  , SALESMAN_CODE    
  , TRANSACTION_DATE 
  , PRODUCT_CODE     
  , QUANTITY   /* Negative values means Product returned by customer*/        
  , GROSS_SALES      
  , TOTAL_DISCOUNT   
  , NET_SALES       
)

SELECT DOCUMENTO_NUMERO
     , EMPRESA
	 , CLIENTE
	 , VENDEDOR
	 , MOVIMENTO
     , PRODUTO
	 , QUANTIDADE 
	 , VENDA_BRUTA
	 , DESCONTO + DESCONTO_NEGOCIADO AS DESCONTO
	 , VENDA_LIQUIDA
  FROM PBS_PROCFIT_DADOS.DBO.VENDAS_ANALITICAS

  
  --

