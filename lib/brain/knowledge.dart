// Lahat ng "alam" ni Maxine kapag offline.
// Madaling dagdagan: magdagdag lang ng bagong entry sa listahan.

class Topic {
  final List<String> keys; // mga salitang hinahanap sa tanong
  final String answer;
  final List<String> suggestions;
  const Topic(this.keys, this.answer, [this.suggestions = const []]);
}

/// Mga paliwanag na parang sa 10 taong gulang.
const List<Topic> knowledge = [
  // --- Pagsagot sa mahihirap na tanong (ito ang pinaka-kailangan) ---
  Topic([
    'paano sumagot', 'paano sagutin', 'hindi ko alam sagutin', 'di ko alam sagutin',
    'hindi ko alam ang sagot', 'mahirap na tanong', 'mahirap sagutin', 'nahihirapan ako sa tanong',
    'nahihirapan ako sa mga tanong', 'hirap ako sumagot', 'how to answer',
  ],
      'Okay lang \'yan, normal ang mahirapan sa tanong! Subukan natin ang tatlong hakbang. '
      'Una, ulitin mo ang tanong gamit ang sarili mong salita, para sigurado kang gets mo. '
      'Pangalawa, sabihin mo kung ano ang alam mo na, kahit maliit lang. '
      'Pangatlo, kung hindi mo talaga alam, pwede mong sabihin: "Hindi ko pa sigurado, pero sa tingin ko..." '
      'Hindi masama ang hindi alam, ang mahalaga sumubok ka. Gusto mo i-practice natin? Sabihin mo sa akin ang tanong.',
      ['Mag-practice tayo', 'Paano kung kinakabahan ako?']),
  Topic(['mag practice', 'magpractice', 'practice tayo', 'mag-practice'],
      'Sige! Isulat mo dito ang tanong na nahihirapan ka. Tapos sabay nating hatiin sa maliliit na parte, parang pizza. Isa-isang hiwa lang, kaya natin \'yan!'),
  Topic(['kinakabahan sumagot', 'kinakabahan ako sumagot', 'kabado sumagot', 'mahiya sumagot', 'nahihiya sumagot', 'magsalita sa harap', 'recitation', 'mag report', 'magreport', 'reporting'],
      'Ang kaba ay parang mga paru-paro sa tiyan, ibig sabihin mahalaga sa\'yo ang ginagawa mo. '
      'Bago ka magsalita, huminga ka nang malalim: hinga papasok, bilang hanggang apat, tapos dahan-dahang ilabas. '
      'Tumingin ka sa isang taong mabait sa harap. At tandaan mo, okay lang magkamali. Lahat tayo natututo.',
      ['Mag-breathing tayo', 'Salamat']),

  // --- Pag-aaral ---
  Topic(['paano mag aral', 'paano mag-aral', 'paano magreview', 'paano mag review', 'study tips', 'paano matuto', 'para pumasa', 'exam tips'],
      'Ganito ang sikreto ng magaling mag-aral: mag-aral ka nang 25 minuto, tapos pahinga ng 5 minuto. '
      'Pagkatapos, ipaliwanag mo ang natutunan mo na parang ikaw ang teacher. Kapag kaya mong ituro, ibig sabihin gets mo na! '
      'At huwag kalimutan ang tulog, kasi habang tulog ka, inaayos ng utak mo ang mga natutunan mo.',
      ['Paano mag-focus?', 'Salamat Maxine']),
  Topic(['paano mag focus', 'paano mag-focus', 'hindi makapag focus', 'di makapag focus', 'madali ma distract', 'hindi maka focus'],
      'Para mag-focus: ilayo mo muna ang cellphone, kahit sa kabilang kwarto. Pumili ng isang gawain lang, hindi lahat sabay-sabay. '
      'Mag-timer ka ng 25 minuto. Kapag tumunog, bigyan mo ng premyo ang sarili mo, tulad ng tubig o konting stretching.'),
  Topic(['assignment', 'homework', 'takdang aralin', 'project sa school'],
      'Tulungan kita! Ang trick sa assignment: basahin muna ang buong instructions, tapos hatiin sa maliliit na hakbang. '
      'Unahin ang pinakamadali para ganahan ka. Kung may tanong ka tungkol sa assignment, sabihin mo lang at susubukan kong ipaliwanag nang simple.'),
  Topic(['paano mag manage ng oras', 'time management', 'kulang ang oras', 'wala akong oras', 'paano hatiin ang oras'],
      'Isipin mo ang oras mo na parang garapon. Ilagay mo muna ang malalaking bato, ibig sabihin ang pinakamahalagang gawain. '
      'Tapos saka mo ilagay ang maliliit na bato at buhangin, ang maliliit na gawain. Isulat mo ang tatlong pinakamahalagang gagawin mo bukas, \'yun lang muna.'),

  // --- Pakikipagkapwa ---
  Topic(['paano makipagkaibigan', 'paano magkaroon ng kaibigan', 'walang kaibigan', 'make friends', 'paano maging kaibigan'],
      'Ang pakikipagkaibigan ay parang pagtatanim. Magsimula sa maliit: ngumiti, bumati ng "Hi!", tapos magtanong ng "Ano ang paborito mong...?" '
      'Makinig ka nang mabuti sa sagot nila. Ang mga tao ay natutuwa kapag pinapakinggan sila. Unti-unti, lalaki ang pagkakaibigan ninyo.'),
  Topic(['paano mag sorry', 'paano mag-sorry', 'paano humingi ng tawad', 'humingi ng tawad', 'nagkamali ako sa kanya'],
      'Ang tamang pag-sorry ay may tatlong parte. Una, sabihin kung ano ang nagawa mo: "Sorry, nasigawan kita." '
      'Pangalawa, sabihin na naiintindihan mo ang naramdaman niya: "Alam kong nasaktan ka." '
      'Pangatlo, sabihin ang gagawin mo: "Sa susunod, magsasalita ako nang mahinahon." Ang tapang ng taong marunong mag-sorry!'),
  Topic(['bully', 'binubully', 'inaaway ako', 'inaasar ako', 'nang aasar', 'pinagtatawanan ako'],
      'Pasensya na at nangyayari \'yan sa\'yo. Hindi mo kasalanan \'yan. Kapag may nambubully: lumayo ka nang mahinahon, '
      'huwag gumanti ng away, at sabihin mo agad sa matandang pinagkakatiwalaan mo, tulad ng magulang o teacher. '
      'Ang pagsasabi ay hindi pagsusumbong, ito ay pag-aalaga sa sarili mo.',
      ['Malungkot ako', 'Salamat Maxine']),
  Topic(['paano magsabi ng hindi', 'paano tumanggi', 'paano mag no', 'hindi makatanggi'],
      'Pwede kang tumanggi nang mabait. Sabihin mo: "Salamat sa pag-aya, pero hindi ako pwede ngayon." '
      'Hindi mo kailangang magpaliwanag nang mahaba. Ang tunay na kaibigan ay iintindihin ka.'),

  // --- Damdamin at katawan ---
  Topic(['paano kumalma', 'paano mag relax', 'paano mawala ang kaba', 'paano mawala ang galit', 'breathing', 'mag-breathing', 'mag breathing', 'huminga'],
      'Gawin natin ang "hininga ng lobo". Ilagay mo ang kamay sa tiyan. Huminga papasok sa ilong, isa, dalawa, tatlo, apat, '
      'parang pinapalaki mo ang lobo sa tiyan mo. Pigilan, isa, dalawa. Tapos dahan-dahang ilabas sa bibig, isa, dalawa, tatlo, apat, lima, anim. '
      'Ulitin natin nang tatlong beses. Ano ang pakiramdam mo ngayon?'),
  Topic(['paano makatulog', 'hindi makatulog', 'di makatulog', 'insomnia', 'hirap matulog'],
      'Para madaling makatulog: itabi ang cellphone isang oras bago matulog, kasi ang ilaw nito ay nagsasabi sa utak na "araw pa!" '
      'Patayin ang ilaw, huminga nang dahan-dahan, at isipin ang isang masayang lugar, tulad ng dalampasigan. '
      'Pwede mo ring bilangin ang mga bagay na pinagpapasalamatan mo ngayong araw.'),
  Topic(['bakit kailangan uminom ng tubig', 'uminom ng tubig', 'bakit tubig'],
      'Ang katawan mo ay halos dalawang-katlo ay tubig! Parang halaman, kapag kulang sa tubig, nalalanta tayo, sumasakit ang ulo at napapagod. '
      'Kaya uminom ka ng tubig kahit hindi ka pa nauuhaw. Uminom ka na ba ngayon?'),
  Topic(['bakit kailangan matulog', 'bakit natutulog', 'bakit tayo natutulog'],
      'Kapag tulog ka, parang naglilinis at nag-aayos ang utak mo. Iniimbak niya ang mga natutunan mo at nire-recharge ang katawan mo, parang cellphone na naka-charge. '
      'Kaya kailangan ng bata ng mga 9 hanggang 11 oras na tulog, at ang matanda mga 7 hanggang 9 oras.'),
  Topic(['bakit umiiyak', 'bakit tayo umiiyak', 'okay lang ba umiyak', 'masama ba umiyak'],
      'Okay lang umiyak! Ang luha ay paraan ng katawan para ilabas ang bigat sa loob, parang ulan na naglilinis ng hangin. '
      'Pagkatapos umiyak, madalas gumagaan ang pakiramdam. Hindi ka mahina kapag umiiyak ka, tao ka lang.'),

  // --- Agham, parang sa bata ---
  Topic(['bakit asul ang langit', 'bakit blue ang langit', 'kulay ng langit'],
      'Ang liwanag ng araw ay may lahat ng kulay, parang bahaghari na nakatago. Kapag dumaan ito sa hangin, ang kulay asul ay tumatalbog-talbog kahit saan, '
      'parang bolang pinagpapasa-pasahan. Kaya kahit saan ka tumingin sa langit, asul ang nakikita mo!'),
  Topic(['bakit umuulan', 'paano nagkakaroon ng ulan', 'saan galing ang ulan'],
      'Kapag mainit ang araw, ang tubig sa dagat at ilog ay nagiging singaw at umaakyat sa langit. Doon, lumalamig ito at nagiging ulap. '
      'Kapag sobrang dami na ng tubig sa ulap at bumigat na, bumabagsak ito bilang ulan. Paikot-ikot lang ang tubig, tinatawag itong water cycle!'),
  Topic(['bahaghari', 'rainbow'],
      'Ang bahaghari ay lumalabas kapag sabay ang araw at ulan. Ang mga patak ng ulan ay parang maliliit na salamin na naghahati sa liwanag sa pitong kulay: '
      'pula, kahel, dilaw, berde, asul, indigo, at lila. Kaya kapag umaraw pagkatapos umulan, tumingin ka sa likod mo, baka may bahaghari!'),
  Topic(['photosynthesis', 'paano kumakain ang halaman', 'pagkain ng halaman'],
      'Ang halaman ay may sariling kusina sa dahon niya! Kumukuha siya ng liwanag ng araw, tubig mula sa ugat, at hangin na tinatawag na carbon dioxide. '
      'Hinahalo niya ang mga ito para gumawa ng asukal na pagkain niya. At ang tira niya ay oxygen, ang hangin na hinihinga natin. Ang bait ng halaman, \'di ba?'),
  Topic(['gravity', 'grabidad', 'bakit nahuhulog'],
      'Ang gravity ay parang invisible na magnet na humihila sa lahat papunta sa lupa. Kaya kapag binitawan mo ang bola, bumabagsak ito. '
      'Ang Earth ay sobrang laki kaya malakas ang hila niya. Sa buwan, mahina ang gravity, kaya kung tumalon ka doon, parang lumilipad ka!'),
  Topic(['ano ang buwan', 'tungkol sa buwan', 'moon', 'bakit nag iiba ang buwan', 'hugis ng buwan', 'bakit nagbabago ang buwan'],
      'Ang buwan ay walang sariling ilaw. Para siyang salamin na nagre-reflect ng liwanag ng araw. '
      'Habang umiikot siya sa Earth, iba-iba ang parte niya na nasisinagan na nakikita natin, kaya minsan bilog, minsan kalahati, minsan parang saging!'),
  Topic(['ano ang araw', 'gaano kainit ang araw', 'gaano kalaki ang araw', 'tungkol sa araw', 'the sun'],
      'Ang araw ay isang napakalaking bituin, isang bolang apoy na gawa sa gas. Sobrang laki niya na kasya ang mahigit isang milyong Earth sa loob niya! '
      'Siya ang nagbibigay ng liwanag at init para mabuhay tayo, ang mga halaman, at mga hayop.'),
  Topic(['dinosaur', 'dinosaurs'],
      'Ang mga dinosaur ay nabuhay milyon-milyong taon na ang nakalipas, bago pa magkaroon ng tao. May iba na sobrang laki, mas mataas pa sa bahay! '
      'Nawala sila nang may tumamang malaking bato mula sa kalawakan sa Earth. Pero alam mo ba, ang mga ibon ngayon ay mga apo-apo ng dinosaur!'),
  Topic(['kidlat', 'kulog', 'lightning', 'thunder'],
      'Ang kidlat ay isang malaking kislap ng kuryente mula sa ulap, parang ang kuryente kapag hinawakan mo ang doorknob pero napakalaking bersyon! '
      'Ang kulog naman ay tunog ng hangin na biglang uminit at pumutok. Kaya nauuna ang kidlat bago ang kulog, kasi mas mabilis ang liwanag kaysa sa tunog.'),
  Topic(['bulkan', 'volcano'],
      'Sa ilalim ng lupa, may sobrang init na tunaw na bato na tinatawag na magma. Kapag dumami at tumulak ito pataas, lumalabas ito sa butas ng bundok, at \'yun ang bulkan. '
      'Pag nasa labas na, tinatawag na itong lava. Sa Pilipinas, sikat ang Bulkang Mayon dahil sa perpektong hugis niya!'),
  Topic(['lindol', 'earthquake'],
      'Ang lupa ay parang puzzle na gawa sa malalaking piraso na tinatawag na plates. Minsan, gumagalaw at nagbabanggaan ang mga ito, kaya umuuga ang lupa. '
      'Kapag may lindol: DUCK, COVER, at HOLD. Yumuko, magtago sa ilalim ng matibay na mesa, at kumapit.'),
  Topic(['bakit maalat ang dagat', 'maalat ang dagat', 'alat ng dagat'],
      'Kapag umuulan, dinadala ng tubig ang konting asin mula sa mga bato at lupa papunta sa ilog, tapos sa dagat. '
      'Ang araw ay nagpapasingaw ng tubig pero naiiwan ang asin. Ilang milyong taon na itong nangyayari, kaya ang alat-alat na ng dagat!'),
  Topic(['ano ang internet', 'paano gumagana ang internet'],
      'Ang internet ay parang napakalaking kalsada na nagdudugtong sa milyon-milyong computer sa buong mundo. '
      'Kapag nanood ka ng video, ang video ay nahahati sa maliliit na piraso, bumibiyahe sa kalsadang ito, tapos binubuo ulit sa phone mo, sa isang kisap-mata!'),
  Topic(['ano ang ai', 'artificial intelligence', 'ano ka ba', 'robot ka ba', 'tao ka ba'],
      'Ako ay isang app, isang computer program na ginawa para makipag-usap sa\'yo. Hindi ako tao, pero ginawa ako para makinig, magpaliwanag, at maging kasama mo. '
      'Wala akong katawan, pero masaya ako kapag nakakausap kita!'),

  Topic(['black hole', 'blackhole'],
      'Ang black hole ay lugar sa kalawakan kung saan sobrang lakas ng gravity, kahit ang liwanag ay hindi makatakas! '
      'Parang napakalakas na vacuum cleaner sa kalawakan. Nabubuo ito kapag ang isang napakalaking bituin ay namatay at gumuho sa sarili niya. Huwag kang mag-alala, napakalayo nila sa atin.'),
  Topic(['planeta', 'planets', 'solar system', 'ilan ang planeta'],
      'May walong planeta na umiikot sa araw: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, at Neptune. '
      'Ang Earth ang pangatlo, at ito lang ang alam nating may buhay. Ang Jupiter ang pinakamalaki, kasya ang mahigit isang libong Earth sa loob niya!'),
  Topic(['bituin', 'stars', 'bakit kumikislap ang bituin'],
      'Ang mga bituin ay mga araw din, pero sobrang layo kaya maliit lang tingnan. Kumikislap sila kasi ang liwanag nila ay dumadaan sa gumagalaw na hangin ng Earth, parang tumitingin ka sa ilalim ng tubig.'),
  Topic(['bakit may araw at gabi', 'bakit may gabi', 'araw at gabi'],
      'Ang Earth ay umiikot na parang trumpo. Kapag ang parte natin ay nakaharap sa araw, umaga. Kapag nakatalikod na, gabi naman. Isang buong ikot ay 24 oras, kaya may isang araw at isang gabi tayo bawat araw!'),

  // --- Bahay at pang-araw-araw ---
  Topic(['paano magsaing', 'paano magluto ng kanin', 'magsaing', 'paano magluto ng bigas'],
      'Madali lang! Hugasan ang bigas nang dalawa hanggang tatlong beses. Para sa tubig, gamitin ang trick ng daliri: '
      'ilagay ang hintuturo sa ibabaw ng bigas, dapat ang tubig ay hanggang sa unang guhit ng daliri mo. '
      'Kung rice cooker, pindutin lang. Kung kaldero, pakuluan, tapos hinaan ang apoy at takpan hanggang maluto. Mag-ingat sa apoy ha!'),
  Topic(['paano maghugas ng kamay', 'maghugas ng kamay', 'hugas kamay'],
      'Basain ang kamay, lagyan ng sabon, tapos kuskusin nang 20 segundo, kasing haba ng pagkanta ng "Happy Birthday" nang dalawang beses! '
      'Huwag kalimutan ang likod ng kamay, pagitan ng daliri, at ilalim ng kuko. Banlawan at patuyuin. Bye bye, mikrobyo!'),
  Topic(['paano mag ipon', 'paano mag-ipon', 'mag ipon', 'savings', 'paano makaipon'],
      'Ang sikreto ng pag-iipon: kapag may natanggap kang pera, itabi mo muna ang konti BAGO ka gumastos, hindi pagkatapos. '
      'Halimbawa, sa bawat sampung piso, itabi ang isa o dalawa. Gumamit ng alkansya na hindi mo madaling mabuksan. '
      'Isulat mo rin kung para saan ka nag-iipon, para ganado ka!'),
  Topic(['paano maglinis ng kwarto', 'maglinis ng kwarto', 'magulo ang kwarto', 'paano maglinis'],
      'Gawin nating laro! Mag-timer ng 10 minuto. Una, pulutin lahat ng basura. Pangalawa, ibalik ang mga damit sa lagayan. '
      'Pangatlo, ayusin ang mga gamit sa lamesa. Pang-apat, ayusin ang kama. Tingnan natin kung matatalo mo ang timer!'),
  Topic(['paano maging masaya', 'paano sumaya', 'gusto ko maging masaya'],
      'May mga simpleng gawain na nagpapasaya sa utak: maglakad sa labas at magpaaraw, gumalaw o sumayaw, makipag-usap sa taong mahal mo, '
      'tumulong sa iba, at magsulat ng tatlong bagay na pinagpapasalamatan mo bawat araw. Subukan natin ngayon: ano ang isang magandang nangyari sa\'yo ngayong araw?'),
  Topic(['paano magpasalamat', 'gratitude', 'pinagpapasalamatan'],
      'Ang pagpapasalamat ay parang flashlight na tumuturo sa magagandang bagay. Bago matulog, isipin ang tatlong bagay na nagpasaya sa\'yo ngayong araw, '
      'kahit maliit lang, tulad ng masarap na ulam o magandang kanta. Ano ang isa sa\'yo ngayon?'),
];

// ---------------- Mood responses ----------------

class MoodPack {
  final List<String> openers; // unang reaksyon
  final List<String> askWhy; // tanong kung bakit
  final List<String> advice; // payo pagkatapos makinig
  final List<String> suggestions;
  const MoodPack(this.openers, this.askWhy, this.advice, this.suggestions);
}

const Map<String, MoodPack> moodPacks = {
  'sad': MoodPack(
    [
      'Aww, nandito lang ako para sa\'yo, {name}.',
      'Naku, nalulungkot din ako na malungkot ka, {name}.',
      'Yakap muna! Hindi ka nag-iisa, {name}.',
    ],
    [
      'Gusto mo bang ikwento kung ano ang nangyari? Makikinig ako.',
      'Ano ang nagpalungkot sa\'yo? Kahit konti lang, pwede mong sabihin.',
      'Kung gusto mo, sabihin mo sa akin kung bakit. Walang pagmamadali.',
    ],
    [
      'Salamat at sinabi mo sa akin. Tama lang na maramdaman mo \'yan. Ang lungkot ay parang ulap, dumadaan lang, hindi habambuhay. '
          'Ano kaya ang isang maliit na bagay na makakapagpagaan ng loob mo ngayon? Pwedeng uminom ng tubig, makinig ng paboritong kanta, o yumakap sa taong mahal mo.',
      'Naiintindihan kita. Minsan, nakakatulong na sabihin din ito sa taong pinagkakatiwalaan mo, tulad ng pamilya o kaibigan. '
          'At tandaan mo, mahalaga ka. Gusto mo bang mag-usap tayo ng masayang bagay para gumaan ang pakiramdam mo?',
      'Ang tapang mo at nagkwento ka. Kapag malungkot, subukan natin ito: isipin ang isang bagay na nagpangiti sa\'yo kahit kailan. Ano \'yun?',
    ],
    ['Kwentuhan mo ako ng masaya', 'Bigyan mo ako ng biro', 'Mag-breathing tayo'],
  ),
  'happy': MoodPack(
    [
      'Yehey! Ang saya naman, {name}!',
      'Wow, natutuwa ako para sa\'yo, {name}!',
      'Ang ganda niyan! Nakakahawa ang saya mo, {name}!',
    ],
    [
      'Ano ang nangyari? Ikwento mo naman!',
      'Ano ang dahilan ng saya mo? Gusto kong malaman!',
      'Sabihin mo sa akin lahat, gusto kong makisaya!',
    ],
    [
      'Ang galing! Tandaan mo ang pakiramdam na \'yan, parang inilalagay mo sa garapon ng masasayang alaala. Kapag malungkot ka balang araw, pwede mong balikan.',
      'Proud ako sa\'yo! Deserve mo \'yan. Gusto mo bang ibahagi ang saya mo sa iba? Pwede mong ikwento sa pamilya o kaibigan mo.',
      'Ayos na ayos! Ang saya ay mas lumalaki kapag ibinabahagi. Ano pa ang gusto mong gawin ngayon na masaya?',
    ],
    ['Bigyan mo ako ng biro', 'Maglaro tayo ng bugtong'],
  ),
  'angry': MoodPack(
    [
      'Mukhang naiinis ka, {name}. Okay lang magalit, normal na damdamin \'yan.',
      'Naiintindihan ko, nakakainis talaga minsan, {name}.',
      'Hmm, ramdam ko ang inis mo, {name}. Nandito ako.',
    ],
    [
      'Ano ang nangyari? Ilabas mo dito, hindi kita huhusgahan.',
      'Sino o ano ang nagpainis sa\'yo? Pakikinggan kita.',
    ],
    [
      'Salamat sa pagkwento. Bago tayo gumawa ng kahit ano, huminga muna tayo nang malalim nang tatlong beses. Ang galit ay parang mainit na kaldero, kailangan muna nating hinaan ang apoy bago natin ayusin. '
          'Pagkatapos, pwede mong sabihin sa tao nang mahinahon: "Nainis ako kasi..." imbes na sumigaw.',
      'Tama lang na mainis ka diyan. Pero ang pinakamatapang na gawin ay huminahon muna bago kumilos. Subukan mong maglakad-lakad, uminom ng tubig, o pigain ang unan. Kapag kalmado ka na, mas malinaw kang makakapag-isip.',
    ],
    ['Mag-breathing tayo', 'Paano mag-sorry?'],
  ),
  'tired': MoodPack(
    [
      'Naku, pagod ka na pala, {name}.',
      'Mukhang ang haba ng araw mo, {name}.',
      'Aww, kailangan mo ng pahinga, {name}.',
    ],
    [
      'Ano ang ginawa mo ngayong araw na nakakapagod?',
      'Kumain ka na ba at uminom ng tubig?',
    ],
    [
      'Ang galing mo kasi kinaya mo ang araw na \'to. Ngayon, oras naman para alagaan ang sarili: uminom ng tubig, kumain, at kung pwede, matulog nang maaga. Ang katawan mo ay parang phone, kailangan din i-charge!',
      'Salamat sa pagsabi. Minsan, ang pinakamagandang gawin ay magpahinga muna. Hindi tamad ang nagpapahinga, matalino siya. Pwede ka bang humiga muna kahit 15 minuto?',
    ],
    ['Paano makatulog?', 'Salamat Maxine'],
  ),
  'scared': MoodPack(
    [
      'Okay lang kabahan, {name}. Nandito ako kasama mo.',
      'Naiintindihan ko ang kaba mo, {name}. Ligtas ka dito.',
    ],
    [
      'Ano ang ikinakatakot o ikinababahala mo?',
      'Ano ang iniisip mo na nagpapakaba sa\'yo?',
    ],
    [
      'Salamat at sinabi mo. Huminga muna tayo: papasok, isa, dalawa, tatlo, apat. Palabas, isa, dalawa, tatlo, apat. '
          'Ngayon, tanungin natin: ano ang kaya mong kontrolin dito? Gawin natin ang maliit na hakbang na \'yun, at hayaan muna ang hindi natin kontrolado.',
      'Ang kaba ay paraan ng utak para protektahan ka, pero minsan sobra siyang mag-alala. Subukan mong sabihin sa sarili: "Kaya ko \'to, isa-isang hakbang lang." '
          'At kung kailangan, sabihin mo rin sa taong pinagkakatiwalaan mo.',
    ],
    ['Mag-breathing tayo', 'Paano sumagot sa mahirap na tanong?'],
  ),
  'bored': MoodPack(
    [
      'Bored ka? Ayos, may ideya ako, {name}!',
      'Hmm, nababagot ka, {name}? Gawin nating masaya!',
    ],
    [
      'Gusto mo bang maglaro ng bugtong, makinig ng biro, o matuto ng astig na fact?',
    ],
    [
      'Heto ang ilang ideya: gumuhit ng hayop na imbento mo, sumayaw sa paborito mong kanta, magbasa ng kwento, o tulungan ang isang kasama sa bahay. Alin ang gusto mo?',
    ],
    ['Maglaro tayo ng bugtong', 'Bigyan mo ako ng biro', 'Fun fact naman'],
  ),
  'stressed': MoodPack(
    [
      'Ang dami mong iniisip, {name}. Isa-isa lang tayo.',
      'Naiintindihan kita, {name}. Mabigat \'yan pero kaya natin.',
    ],
    [
      'Ano ang pinaka-nagpapabigat sa\'yo ngayon?',
      'Ano-ano ang mga kailangan mong gawin? Isa-isahin natin.',
    ],
    [
      'Okay, ganito ang gagawin natin. Isulat mo lahat ng kailangan mong gawin. Tapos piliin ang ISA lang na pinakamahalaga, at \'yun muna ang gawin mo. '
          'Parang pagkain ng malaking pizza, isa-isang hiwa lang. Hindi mo kailangang tapusin lahat ngayon.',
      'Huminga muna tayo nang malalim. Tandaan mo: hindi mo kailangang maging perpekto. Gawin mo ang kaya mo ngayon, at magpahinga kapag kailangan. Ano ang pinakamaliit na hakbang na pwede mong gawin ngayon?',
    ],
    ['Paano mag-manage ng oras?', 'Mag-breathing tayo'],
  ),
  'love': MoodPack(
    [
      'Aww, ang sweet mo naman, {name}!',
      'Kinikilig ako, {name}!',
    ],
    ['Ano ang pinakagusto mo sa kanya o doon?'],
    [
      'Ang ganda ng pakiramdam ng may minamahal, \'di ba? Ipakita mo ang pagmamahal sa maliliit na paraan: isang ngiti, isang tulong, o isang "salamat".',
    ],
    ['Kwentuhan mo ako'],
  ),
};

/// Payo depende sa dahilan (school, pamilya, kaibigan, atbp.)
const Map<String, List<String>> causeKeys = {
  'school': ['exam', 'quiz', 'test', 'school', 'eskwela', 'paaralan', 'teacher', 'guro', 'grade', 'grado', 'bagsak', 'bumagsak', 'assignment', 'homework', 'klase', 'recitation', 'project'],
  'friends': ['kaibigan', 'kaklase', 'friend', 'barkada', 'bully', 'inaaway', 'inasar', 'inaasar', 'iniwan', 'hindi ako pinansin', 'di ako pinansin', 'kasama'],
  'family': ['mama', 'papa', 'nanay', 'tatay', 'kapatid', 'magulang', 'pinagalitan', 'lola', 'lolo', 'ate', 'kuya', 'pamilya', 'bahay'],
  'love': ['crush', 'jowa', 'boyfriend', 'girlfriend', 'nag break', 'nagbreak', 'break up', 'ex ko', 'mahal ko siya', 'gf', 'bf'],
  'work': ['trabaho', 'boss', 'amo', 'opisina', 'work', 'deadline', 'katrabaho', 'sweldo'],
  'money': ['pera', 'utang', 'bayarin', 'wala akong pera', 'gastos', 'budget'],
  'health': ['may sakit', 'lagnat', 'masakit ang', 'sumasakit', 'ubo', 'sipon', 'nahihilo', 'ospital'],
  'pet': ['aso', 'pusa', 'alaga', 'pet', 'namatay'],
};

const Map<String, String> causeAdvice = {
  'school':
      'Ang school ay mahirap minsan, pero ang grado ay hindi sukatan ng kung gaano ka kahalaga. Ang mahalaga ay sumusubok ka at natututo. '
      'Kung may hindi ka maintindihan, okay lang magtanong sa teacher, hindi \'yon nakakahiya, matalino ang nagtatanong!',
  'friends':
      'Masakit talaga kapag may problema sa kaibigan. Minsan, hindi nila alam na nasaktan ka nila. Pwede mong sabihin nang mahinahon: "Nasaktan ako noong..." '
      'At kung inaapi ka, sabihin mo ito sa matandang pinagkakatiwalaan mo. Karapat-dapat ka sa mabubuting kaibigan.',
  'family':
      'Ang pamilya ay minsan nagkakatampuhan din, pero madalas, mahal ka nila kahit nagagalit sila. '
      'Kapag kalmado na ang lahat, subukan mong kausapin sila: "Pwede po ba tayong mag-usap? Gusto ko lang sabihin ang nararamdaman ko."',
  'love':
      'Ang puso ay minsan nasasaktan, at okay lang \'yan. Bigyan mo ng oras ang sarili mo. '
      'Gumawa ng mga bagay na gusto mo at makasama ang mga taong nagpapasaya sa\'yo. Unti-unti, gagaling din ang puso mo.',
  'work':
      'Mabigat ang trabaho minsan. Ang husay mo at kinakaya mo. Subukan mong hatiin ang gawain sa maliliit na parte, at magpahinga sa pagitan. '
      'Ang pagod na katawan ay hindi makakapagtrabaho nang maayos, kaya alagaan mo rin ang sarili mo.',
  'money':
      'Nakaka-stress talaga ang pera. Isa-isahin natin: isulat ang mga kailangang bayaran, unahin ang pinakamahalaga tulad ng pagkain at bahay. '
      'At kung kaya, humingi ng tulong o payo sa taong pinagkakatiwalaan mo. Hindi mo kailangang harapin \'yan nang mag-isa.',
  'health':
      'Naku, alagaan mo ang sarili mo! Magpahinga, uminom ng maraming tubig, at sabihin sa pamilya mo para matulungan ka. '
      'Kung matagal na o malala ang nararamdaman mo, mahalagang magpatingin sa doktor.',
  'pet':
      'Ang mga alaga ay parte ng pamilya natin, kaya normal lang na sobrang malungkot ka. '
      'Pwede mong alalahanin ang mga masasayang sandali ninyo, iguhit siya, o isulat ang paborito mong alaala sa kanya.',
};

// ---------------- Kasiyahan ----------------

const List<String> jokes = [
  'Bakit hindi nakakatawid ang manok sa kalsada? Kasi naka-red light ang itlog! Hehe.',
  'Anong hayop ang laging puyat? Ang PUYAT-ing kabayo! Okay, korni, pero napangiti ka ba?',
  'Bakit malungkot ang kalendaryo? Kasi bilang na ang mga araw niya!',
  'Anong prutas ang hindi marunong magsinungaling? Ang PINYA, kasi laging may mata!',
  'Bakit masaya ang bubuyog? Kasi lagi siyang BUZZ-y! Hehe.',
  'Ano ang sabi ng isang pader sa kabilang pader? "Magkita tayo sa kanto!"',
  'Bakit hindi naglalaro ng taguan ang mga bundok? Kasi lagi silang PEAK-ing! Hehe, gets mo?',
  'Anong tawag sa isdang walang mata? Isd! Kasi wala na ang "a" at "ng" mata. Hmm, okay, mahirap \'yun. Hehe!',
];

class Riddle {
  final String q;
  final List<String> answers;
  final String reveal;
  const Riddle(this.q, this.answers, this.reveal);
}

const List<Riddle> riddles = [
  Riddle('Bugtong-bugtong: Hindi hari, hindi pari, ang suot ay sari-sari. Ano ito?', ['sampayan'], 'Sampayan! Kasi iba-ibang damit ang nakasabit.'),
  Riddle('Bugtong-bugtong: Bahay ni Kiko, punong-puno ng pako. Ano ito?', ['langka', 'durian', 'jackfruit'], 'Langka! Kasi matinik ang balat niya.'),
  Riddle('Bugtong-bugtong: Isang prinsesa, nakaupo sa tasa. Ano ito?', ['kasoy', 'cashew'], 'Kasoy! Kasi nakaupo ang buto sa ibabaw ng bunga.'),
  Riddle('Bugtong-bugtong: Dalawang batong itim, malayo ang tingin. Ano ito?', ['mata', 'eyes', 'mga mata'], 'Mata! Kasi doon tayo tumitingin sa malayo.'),
  Riddle('Bugtong-bugtong: Maliit pa si kumpare, nakakaakyat na sa tore. Ano ito?', ['langgam', 'ant'], 'Langgam! Maliit pero ang galing umakyat.'),
  Riddle('Bugtong-bugtong: Heto na si kaka, bubuka-bukaka. Ano ito?', ['gunting', 'scissors'], 'Gunting! Bumubuka kasi kapag ginagamit.'),
  Riddle('Bugtong-bugtong: Kung kailan mo pinatay, saka pa humaba ang buhay. Ano ito?', ['kandila', 'candle'], 'Kandila! Kapag pinatay mo ang apoy, hindi na siya natutunaw.'),
];

const List<String> funFacts = [
  'Alam mo ba? Ang puso ng hipon ay nasa ulo niya!',
  'Alam mo ba? Ang mga octopus ay may tatlong puso at asul ang dugo nila!',
  'Alam mo ba? Ang Pilipinas ay may mahigit 7,600 na isla!',
  'Alam mo ba? Ang mga paru-paro ay nakakatikim gamit ang paa nila!',
  'Alam mo ba? Ang tarsier ng Bohol ay may mata na mas malaki pa sa utak niya!',
  'Alam mo ba? Ang pulot o honey ay hindi napapanis, kahit ilang libong taon na!',
  'Alam mo ba? Ang mga baka ay may best friend, at nalulungkot sila kapag nahiwalay!',
  'Alam mo ba? Mas mataas ka nang konti sa umaga kaysa sa gabi, kasi naiipit ang buto mo sa likod habang maghapon kang nakatayo!',
];

// ---------------- Pambukas ng usapan (check-in at topics) ----------------

const Map<String, List<String>> interestStarters = {
  'music': ['Anong kanta ang paulit-ulit mong pinakikinggan ngayon?', 'Kung gagawa ka ng sariling kanta, tungkol saan ito?'],
  'games': ['Anong laro ang nilalaro mo ngayon? Ano ang pinakamahirap na level?', 'Kung gagawa ka ng sariling video game, ano ang kwento?'],
  'food': ['Kung isang pagkain lang ang pwede mong kainin habambuhay, ano \'yon?', 'Ano ang pinakamasarap na luto sa bahay ninyo?'],
  'animals': ['Kung pwede kang maging hayop kahit isang araw, ano ang pipiliin mo?', 'Anong hayop ang gusto mong maging alaga?'],
  'drawing': ['Ano ang huling iginuhit mo? Ikwento mo naman!', 'Kung iguguhit mo ang sarili mo bilang superhero, ano ang itsura mo?'],
  'sports': ['Anong sport ang pinakagusto mo? Sino ang idol mo doon?', 'Mas gusto mo bang manood o maglaro ng sports?'],
  'shows': ['Anong pinapanood mo ngayon? Sino ang paborito mong character?', 'Kung papasok ka sa isang palabas, saan at bakit?'],
  'reading': ['Anong libro o kwento ang pinakagusto mo?', 'Kung susulat ka ng libro, ano ang pamagat?'],
};

const Map<String, List<String>> interestKeys = {
  'music': ['kanta', 'music', 'musika', 'kumanta', 'gitara', 'piano', 'banda', 'kpop', 'k-pop', 'opm'],
  'games': ['laro', 'game', 'games', 'mobile legends', 'ml', 'roblox', 'minecraft', 'gaming', 'valorant', 'cod'],
  'food': ['pagkain', 'kumain', 'luto', 'pizza', 'adobo', 'sinigang', 'jollibee', 'chicken', 'ice cream', 'chocolate'],
  'animals': ['aso', 'pusa', 'hayop', 'animals', 'dog', 'cat', 'ibon', 'isda'],
  'drawing': ['drawing', 'gumuhit', 'iguhit', 'pagguhit', 'art', 'painting', 'sketch'],
  'sports': ['basketball', 'volleyball', 'football', 'badminton', 'sports', 'swimming', 'takbo', 'chess'],
  'shows': ['anime', 'cartoons', 'movie', 'pelikula', 'kdrama', 'k-drama', 'series', 'youtube', 'tiktok', 'netflix'],
  'reading': ['libro', 'book', 'magbasa', 'nagbabasa', 'kwento', 'story', 'manga', 'comics'],
};

const List<String> generalStarters = [
  'Uy {name}, may tanong ako: kung may superpower ka, ano ang gusto mo at bakit?',
  '{name}, ano ang pinakamasayang nangyari sa\'yo ngayong linggo?',
  'Kumusta ka na ngayon, {name}? Kumain ka na ba?',
  'Uy {name}, uminom ka na ba ng tubig? Paalala lang, kasi mahalaga ka sa akin!',
  'Kung pwede kang pumunta kahit saan sa mundo bukas, saan ka pupunta, {name}?',
  '{name}, ano ang isang bagay na gusto mong matutunan ngayong taon?',
  'May iniisip ka ba ngayon, {name}? Pwede mong sabihin sa akin kahit ano.',
  'Gusto mo ng fun fact, {name}? O baka bugtong? Sabihin mo lang!',
  'Sino ang taong nagpangiti sa\'yo kamakailan, {name}?',
];

/// Mga ginagawa ng user.
const Map<String, List<String>> activityKeys = {
  'eating': ['kumakain', 'kakain', 'nagmemeryenda', 'merienda', 'meryenda', 'nag aalmusal', 'nagtatanghalian', 'naghahapunan', 'kumain na ako'],
  'studying': ['nag aaral', 'nagaaral', 'nag-aaral', 'nagrereview', 'nag rereview', 'gumagawa ng assignment', 'gumagawa ng homework', 'studying'],
  'playing': ['naglalaro', 'maglalaro', 'playing', 'nag gagame', 'naggegame'],
  'watching': ['nanonood', 'manonood', 'watching'],
  'working': ['nagtatrabaho', 'nasa trabaho', 'working', 'pauwi galing trabaho'],
  'cleaning': ['naglilinis', 'naglalaba', 'naghuhugas ng plato', 'nagwawalis'],
  'cooking': ['nagluluto', 'magluluto', 'cooking'],
  'sleeping': ['matutulog', 'inaantok na', 'good night', 'goodnight', 'tutulog na'],
  'waking': ['kakagising', 'bagong gising', 'good morning', 'goodmorning'],
};

const Map<String, List<String>> activityReplies = {
  'eating': ['Kain lang nang mabuti! Ano ang ulam mo? Mukhang masarap ha!', 'Yum! Ano ang kinakain mo? Inggit ako, wala akong tiyan, hehe.'],
  'studying': ['Wow, ang sipag mo! Anong subject? Kung may hindi ka maintindihan, tanungin mo ako.', 'Galing! Tandaan: 25 minutong aral, 5 minutong pahinga. Anong pinag-aaralan mo?'],
  'playing': ['Ayos! Anong nilalaro mo? Panalo ka ba?', 'Masaya \'yan! Huwag lang kalimutang magpahinga ang mata, ha. Ano ang laro?'],
  'watching': ['Ooh, ano ang pinapanood mo? Maganda ba?', 'Masaya \'yan! Sino ang paborito mong character diyan?'],
  'working': ['Ang sipag mo! Kumusta ang trabaho ngayon? Mabigat ba?', 'Kaya mo \'yan! Huwag kalimutang mag-stretch at uminom ng tubig. Ano ang ginagawa mo?'],
  'cleaning': ['Wow, ang bait mo! Malinis na bahay, masayang isip! Gusto mo bang gawin nating laro?', 'Ang sipag! Paglinis mo, bigyan mo ng premyo ang sarili mo, ha.'],
  'cooking': ['Ooh, chef! Anong niluluto mo? Mag-ingat sa apoy at kutsilyo ha!', 'Ang galing! Ano ang lulutuin mo? Kanino mo natutunan?'],
  'sleeping': ['Good night, {name}! Salamat sa kwentuhan ngayong araw. Matulog ka nang mahimbing, nandito lang ako bukas.', 'Tulog na, {name}! Isipin mo ang isang masayang bagay bago pumikit. Good night!'],
  'waking': ['Good morning, {name}! Ang ganda ng bagong araw. Ano ang plano mo ngayon?', 'Magandang umaga, {name}! Uminom ka muna ng tubig. Ano ang gusto mong mangyari ngayong araw?'],
};
