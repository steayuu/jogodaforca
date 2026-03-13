-- Lista com 5 palavras que o jogo pode escolher
-- Escolhi personagens de One Piece
local palavras = { "mihawk", "doflamingo", "hancock", "zoro", "kaido" }

-- Aqui eu ativo o aleatório usando o horário do PC e sorteio uma palavra da lista.
math.randomseed(os.time())
local palavra = palavras[math.random(1, #palavras)]

-- Aqui eu crio um vetor de verdadeiro/falso pra cada letra da palavra. No começo tudo é false.
-- porque no começo nenhuma letra foi descoberta
local descobertas = {}

for i = 1, #palavra do
  descobertas[i] = false
end

-- eu guardo letras já tentadas pra não repetir e controlo o limite de 5 erros
local tentadas = {}
local erros = 0
local MAX_ERROS = 5


-- Essa função monta o que aparece na tela: letra real se foi descoberta, senão *
local function construirMascara()

  local r = {}
  for i = 1, #palavra do

    if descobertas[i] then
      r[#r+1] = palavra:sub(i, i)
    else
      r[#r+1] = "*"
    end
  end
  return table.concat(r)
end


-- verifico se ainda existe alguma letra não descoberta. Se não existir, o jogador venceu.
local function venceu()

  for i = 1, #descobertas do
    if not descobertas[i] then
      return false
    end
  end
  return true
end


-- Aqui eu leio a letra do usuário e valido: 
-- não pode vazio, tem que ser letra e não pode repetir.
local function lerLetra()

  io.write("\nDigite UMA letra: ")
  local entrada = io.read()
  if not entrada or entrada == "" then
    return nil, "Entrada vazia."
  end

  -- pega apenas o primeiro caractere digitado
  -- e transforma em minúsculo
  local letra = entrada:lower():sub(1, 1)

  -- verifica se é realmente uma letra
  if not letra:match("%a") then
    return nil, "Digite apenas uma letra (A-Z)."
  end

  -- verifica se a letra já foi tentada antes
  if tentadas[letra] then
    return nil, "Você já tentou essa letra."
  end

  return letra, nil
end


-- Esse é o loop principal: ele roda enquanto eu não atingi 5 erros e ainda não venci.
while erros < MAX_ERROS and not venceu() do

  -- Aqui eu mostro a palavra mascarada e quantos erros a pessoa tem.
  print("\nPalavra: " .. construirMascara())
  print("Erros: " .. erros .. "/" .. MAX_ERROS)

  -- lê a letra digitada pelo jogador
  local letra, msg = lerLetra()

  -- Se a entrada for inválida, eu só mostro o aviso e continuo o jogo.
  if not letra then
    print("⚠️ " .. msg)

  else

    -- marca essa letra como já tentada para impedir repetição
    tentadas[letra] = true

    local acertou = false

    -- Aqui eu percorro a palavra. Se a letra bate, marco aquela posição como descoberta.
    for i = 1, #palavra do

      if palavra:sub(i, i) == letra then
        descobertas[i] = true
        acertou = true
      end
    end

    -- Se acertar eu só aviso. Se errar eu incremento o contador de erros.
    if acertou then
      print("Acertou!")
    else
      erros = erros + 1
      print("Errou! (+1 erro)")
    end
  end
end


-- No final eu mostro a palavra correta e digo se venceu ou perdeu.
print("\nPalavra final: " .. palavra)
if venceu() then
  print("Você venceu!")
else
  print("Você perdeu!")
end