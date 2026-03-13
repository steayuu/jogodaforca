local palavras = { "mihawk", "doflamingo", "hancock", "zoro", "kaido" }

math.randomseed(os.time())
local palavra = palavras[math.random(1, #palavras)]

local descobertas = {}

for i = 1, #palavra do
  descobertas[i] = false
end

local tentadas = {}
local erros = 0
local MAX_ERROS = 5

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

local function venceu()

  for i = 1, #descobertas do
    if not descobertas[i] then
      return false
    end
  end
  return true
end

local function lerLetra()

  io.write("\nDigite UMA letra: ")
  local entrada = io.read()
  if not entrada or entrada == "" then
    return nil, "Entrada vazia."
  end

  local letra = entrada:lower():sub(1, 1)

  if not letra:match("%a") then
    return nil, "Digite apenas uma letra (A-Z)."
  end

  if tentadas[letra] then
    return nil, "Você já tentou essa letra."
  end

  return letra, nil
end

while erros < MAX_ERROS and not venceu() do

  print("\nPalavra: " .. construirMascara())
  print("Erros: " .. erros .. "/" .. MAX_ERROS)

  local letra, msg = lerLetra()

  if not letra then
    print("⚠️ " .. msg)

  else

    tentadas[letra] = true

    local acertou = false

    for i = 1, #palavra do

      if palavra:sub(i, i) == letra then
        descobertas[i] = true
        acertou = true
      end
    end

    if acertou then
      print("Acertou!")
    else
      erros = erros + 1
      print("Errou! (+1 erro)")
    end
  end
end

print("\nPalavra final: " .. palavra)
if venceu() then
  print("Você venceu!")
else
  print("Você perdeu!")
end
