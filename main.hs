import Data.Char (isDigit)
import System.IO (hFlush, stdout)

sumaAlicuota :: Int -> Int
sumaAlicuota n = sum [i | i <- [1..(n-1)], n `mod` i == 0]

clasificarCategoria :: Int -> String
clasificarCategoria n
  | n < sumaAlicuota n  = "Administrative"
  | n == sumaAlicuota n = "Engineering"
  | n > sumaAlicuota n  = "Humanities"

extraerPeriodo :: String -> String
extraerPeriodo "262" = "2026-2"
extraerPeriodo "271" = "2027-1"
extraerPeriodo "272" = "2027-2"
extraerPeriodo "281" = "2028-1"
extraerPeriodo "282" = "2028-2"
extraerPeriodo "291" = "2029-1"
extraerPeriodo "292" = "2029-2"
extraerPeriodo _     = "Periodo_Invalido"


formatearConsecutivo :: String -> String
formatearConsecutivo str = "num" ++ show (read str :: Int)


determinarParidad :: Int -> String
determinarParidad n
  | n `mod` 2 == 0 = "even"
  | otherwise      = "odd"


esCodigoValido :: String -> Bool
esCodigoValido codigo = 
    length codigo == 8 && 
    all isDigit codigo &&
    (take 3 codigo `elem` ["262", "271", "272", "281", "282", "291", "292"])


analizarCodigo :: String -> String
analizarCodigo codigo
    | not (esCodigoValido codigo) = "Error: El codigo es invalido. Debe tener 8 digitos y un periodo entre 262 y 292."
    | otherwise = 
        let 
            periodoStr = extraerPeriodo (take 3 codigo)
            categoriaStr = clasificarCategoria (read (take 2 (drop 3 codigo)) :: Int)
            consecutivoStr = formatearConsecutivo (drop 5 codigo)
            paridadStr = determinarParidad (read codigo :: Int)
        in periodoStr ++ " " ++ categoriaStr ++ " " ++ consecutivoStr ++ " " ++ paridadStr


main :: IO ()
main = do
    putStr "Ingrese el codigo de estudiante (o 'salir' para terminar): "
    hFlush stdout 
    entrada <- getLine
    
    if entrada == "salir"
        then putStrLn "Saliendo del programa..."
        else do
            putStrLn $ analizarCodigo entrada
            putStrLn "------------------------------------------------"
            main
