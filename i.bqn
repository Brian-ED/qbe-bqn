_I_ ← {𝕨𝕗_𝕣_𝕘⁼𝕩: 𝕨𝔾𝕩 ; 𝕨𝕗_𝕣_𝕘𝕩: 𝕨𝔽𝕩 }
#_A ← {𝔽_I_𝔽⊸⊢} # Assert's inverse is theoretically 1? Or the assertion applies in both directions, I'm not sure. I'll do both directions just in case.
#ie ← "QBE-BQN: INTERNAL ERROR: "
#C ← {𝕊: !2 ⋄ ⊣´𝕩; 𝕊⁼: !ie∾"Accidentally inverted getting a code string"   } # code string
#D ← {𝕊: !2 ⋄ ⊢´𝕩; 𝕊⁼: !ie∾"Accidentally inverted getting a data int array"} # data int array
#_M_ ← {a‿b Code _𝕣_ Data c‿d: 1==¨𝕨∾𝕩? ∧´=○•Type⟜0¨𝕨D𝕩?∧´=○•Type⟜0¨𝕨C𝕩? 𝕨(Code⋈Data)𝕩}
#                           ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ This could seem redundant since if the output of GroupSyntax is required as input to Alternative, why not just have Alternative apply GroupSyntax directly? It's because sometimes you have another function returning something which is in the codomain of GroupSyntax
#⊢⌾(GroupSyntax⁼)_I_...

# TODO: Double check when done
#   Temporary vars can only be a base type

InBetween ← {
    Inv ← (∨`≠↑𝕩⊸⍷)⌾⌽⊸(¬⊸/⋈˜𝕩∾˜⁼/)
    Nor ← ∾⟜𝕩⊸∾´
    errInSA ← """"∾𝕩∾""" is not allowed in the second element of the argument"
    errBadP ← "A prefix of """∾𝕩∾""" is not allowed in the second element of the argument"
    ps ← (⋈∾˜⁼⟨⟨⟩⟩∾⁼⌽¨∘↑/˜↑≡¨⌽¨∘⌽∘↓)𝕩 # Prefix set of invalid prefixes
    Asrt1←errInSA!·∧´∘¬𝕩⍷1⊸⊑
    Asrt2←errBadP!·∧´∘⥊ps≢⌜○•Show·↑1⊸⊑ # Ensure if the prefix appeared in the suffix of 𝕩, that the connected string doesn't form the to-be-split primitive
    Nor∘(Asrt2⊸⊢Asrt1⊸⊢) _I_ Inv
}



                   Keyword ← '"'⊸(∾∾⊣)               # TODOO assert input is a string
               Alternative ← (InBetween" | "){𝔽}     # TODOO add assertions about what the contents need to be # TODOO extra checks are needed on strings + Assert inputs are strings
               GroupSyntax ← 1⌽")("⊸∾                # TODOO assert input is a string
MarkNestedSyntaxAsOptional ← 2⌽" ][ "⊸∾              # TODOO assert input is a string, and it is a "nested syntax"
                      List ← " ),"∾˜"( "∾','∾⁼','∾¨⊢ # TODOO should only accept a list of enclosed syntax. Only strings too. Empty strings shouldn't be allowed in input list I believe?
             AnyRepitition ← ∾⟜'*'                   # TODOO checks
       OneOrMoreRepitition ← ∾⟜'+'                   # TODOO checks
             AggregateType ← ':'⊸∾                   # TODOO has to be a valid variable
                    Global ← '$'⊸∾                   # represented by a pointer # TODOO has to be a valid variable
                TempInFunc ← '%'⊸∾                   # TODOO has to be a valid variable and can only be a base type
                BlockLabel ← '@'⊸∾                   # TODOO has to be a valid variable

{ # Test 1
    x←"abc"‿" def"
    !"abc |  def"    ≡x Alternative       ↩
    !"abc |  def | c"≡x Alternative∘⋈⟜"c" ↩
    !"abc |  def"‿"c"≡x Alternative⁼      ↩
    !"abc"‿" def"    ≡x ⋈⟜"c"∘Alternative⁼↩
}
•Exit 0
# Spacing
#  NL := '\n'+
#  Individual tokens in IL files must be separated
#  by one or more spacing characters. Both spaces
#  and tabs are recognized as spacing characters.
#  In data and type definitions, newlines may also
#  be used as spaces to prevent overly long lines.
#  When exactly one of two consecutive tokens is a
#  symbol (for example , or = or {), spacing may be
#  omitted.

# Types
baseTypes ← i32OrStrippedI64‿i64‿f32‿f64 ← "wlsd" # Base types # TODO Is there a word for "Only the 32 least significant bits of a 64 bit value are used". Stripped?
extendedTypes ← baseTypes ∾ i8‿i16 ← "bh" # They are used in Aggregate Types and Data definitions

IsIdentifier ← ⊢ # TODOOO
#i ← "𝕩 is a number but not an integer"!𝕩≡⌈⌊𝕩 ⋄ ("-"/˜0>𝕩)∾•Repr|𝕩 (!0≡○•Type𝕩)  # TODO Verify if float literals are allowed as numbers: "Integer isn't in bounds (!(𝕩≤¯1+2⋆64)∧(𝕩≥-2⋆64))"!(𝕩≤¯1+2⋆64)∧(𝕩≥-2⋆64)
Const ← {0?@
    ;I      𝕩: 𝕩 # TODOOO
    ;F32    𝕩: "s_"∾•Repr 𝕩
    ;F64    𝕩: "d_"∾•Repr 𝕩
    ;Global 𝕩: !∧´𝕩∊⥊"aA"+⌜↕26 ⋄ ⊢⌾(Global⁼) IsIdentifier 𝕩
}

#DYNCONST :=
#    CONST
#  | 'thread' $IDENT  # Thread-local symbol
#
#VAL :=
#    DYNCONST
#  | %IDENT

