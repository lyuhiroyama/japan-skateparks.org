-- Full Japanese text for skatepark articles (description, history, facilities, surface, addresses).
-- Skips: sumida-skateboard-park, edias-skatepark (maintain manually).
-- Run once: mysql -u USER -p japan_skateparks < sql/migrate_populate_skatepark_ja.sql

USE japan_skateparks;

UPDATE skateparks SET
  city_ja = '江東区',
  address_ja = '〒135-0063 東京都江東区有明2-2',
  description_ja = '有明アーバンスポーツパークは、東京2020オリンピック・パラリンピックのメイン会場の一つとして建設された、有明（江東区）の世界水準のスケートボード・アーバンスポーツ施設です。ストリート・パーク両種目の競技会場となり、現在も国内外のトップ選手が使う競技レベルのコースを一般に公開しています。',
  history_ja = '2020年の東京大会向けに整備され、2021年7月25〜26日にストリート、8月4〜5日にパークの男女競技が開催されました。大会後は恒久施設として再編され、2022年から一般利用が可能になり、以降も国内外の大会が開かれています。',
  facilities_ja = 'オリンピック規格のストリートコース、パークコース、観客席、更衣室、レンタル、飲食、救護、ロッカー',
  surface_type_ja = '滑らかなコンクリート',
  closed_days_ja = '火曜日（祝日の場合は翌平日）、祝日の翌日',
  admission_fee_ja = '大人1,000円／学生500円／小学生以下300円（料金は変更の場合あり）'
WHERE slug = 'ariake-urban-sports-park';

UPDATE skateparks SET
  city_ja = '渋谷区',
  address_ja = '東京都渋谷区（渋谷駅周辺・宮下パークほか）',
  description_ja = '渋谷区内外に点在する、ストリートスケートの聖地的スポット群です。渋谷駅周辺、宮下パーク、代官山・中目黒方面など、長年スケーターのたまり場になってきました。2020年に再開発で開業した宮下パークには屋上の公認スケートエリアがあります。',
  history_ja = '1990年代から渋谷駅前は若者スケーターの中心地の一つでした。2020年、三井不動産等による宮下パークの再開発で商業・ホテル・スポーツが一体となった縦型公園が誕生し、屋上にスケートスペースが設けられました。',
  facilities_ja = '宮下パーク屋上スケートエリア、階段・レッジ、マニュアル台など（エリアにより異なる）',
  surface_type_ja = 'コンクリート・タイル',
  closed_days_ja = 'なし（宮下パーク屋上の場合は施設に準ずる）',
  admission_fee_ja = '無料（宮下パーク屋上エリア）'
WHERE slug = 'shibuya-skate-spot';

UPDATE skateparks SET
  city_ja = '世田谷区',
  address_ja = '〒154-0012 東京都世田谷区駒沢公園1-1',
  description_ja = '1964年東京オリンピックの会場となった駒沢オリンピック公園内にある、都内有数の屋外スケートパークです。緩やかなバンクからランチボックス、クォーター・ヒップ、ミニハーフ、マニーパッド、ベンチまで揃い、初心者から上級者まで幅広く利用できます。入場無料でアクセスしやすい公園施設です。',
  history_ja = '駒沢公園は1964年大会のバレーボール会場として造られ、その後都民のスポーツ・レクリエーション拠点となりました。スケートエリアは長年かけて拡充され、首都圏スケートシーンの定番スポットの一つになっています。',
  facilities_ja = 'バンク、ランチボックス、クォーターパイプヒップ、ミニハーフ複数、マニーパッド、ベンチ、売店近接',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'komazawa-olympic-park-skatepark';

UPDATE skateparks SET
  city_ja = '大田区',
  address_ja = '〒140-0003 東京都大田区城南島4-2-2',
  description_ja = '埋め立て地の城南島・城南島海浜公園内にあり、東京湾や東京港の貨物船、羽田への着陸機を眺めながら滑れる開放的な屋外パークです。ハーフパイプ、クォーター、グラインドボックス、レール、フラットなど、ストリートからトランジションまで幅広く楽しめます。',
  history_ja = '1991年7月、首都圏の埋立整備の一環として城南島海浜公園が開園。スケートエリアは30年以上にわたり地元・首都圏のスケーターに利用され、湾岸ならではのロケーションが人気です。',
  facilities_ja = 'ハーフパイプ、バンクツーバンク、スパイン、クォーター、ボックス、フラットレール、フラット',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '水曜（祝日の場合は翌平日）、12月29日〜1月3日',
  admission_fee_ja = '無料'
WHERE slug = 'jonanjima-seaside-park-skatepark';

UPDATE skateparks SET
  city_ja = '世田谷区',
  address_ja = '〒154-0001 東京都世田谷区池尻1-5-27',
  description_ja = '世田谷公園内の通称「SLパーク」。スケートボード・インライン用エリアが2つと、BMX・フラット向けゾーンに分かれた多目的屋外施設です。家族連れにも馴染みやすく、区立公園として整備された環境で滑れます。',
  history_ja = '公園内のSL（蒸気機関車）展示で知られる池尻の世田谷公園に、スポーツ拡充の一環として設置されました。地域の若者やスケートコミュニティの拠点の一つです。',
  facilities_ja = 'スケートエリア1・2（スケボー・インライン）、BMX・フラット用エリア',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'setagaya-park-skatepark';

UPDATE skateparks SET
  city_ja = '世田谷区',
  address_ja = '〒157-0075 東京都世田谷区砧公園1-1',
  description_ja = '都立砧公園（約39ha）内、有料駐車場近くの景観門側にあるコンパクトな屋外パークです。スケートボード・インライン専用のセクションが複数あり、無料で西部世田谷（用賀・二子玉川方面）の滑り手に利用されています。',
  history_ja = '都が管理する砧公園は広い芝生や桜、隣接する世田谷美術館でも知られます。住宅地に近いスケート環境を提供するためのエリアとして設けられました。',
  facilities_ja = '複数のスケートセクション（スケボー・インライン専用）',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'kinuta-park-skatepark';

UPDATE skateparks SET
  city_ja = '港区',
  address_ja = '〒108-0023 東京都港区芝浦4-20',
  description_ja = '芝浦運河沿い・湊橋（ゆなぎばし）高架下にある小さなスケートスペース。バスケコートと併設され、都心の再開発が進む芝浦エリアでは貴重な公認の滑走スペースです。橋の下なので日射や小雨を多少しのげます。',
  history_ja = '港区の運河沿い整備の一環として、高架下遊具・スポーツスペースとして整備されました。密集市街地での遊び場確保の工夫の一例です。',
  facilities_ja = 'スケート用リング、バスケットコート',
  surface_type_ja = '滑らかなコンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'tamachi-skate-board-space';

UPDATE skateparks SET
  city_ja = '渋谷区',
  address_ja = '〒150-0001 東京都渋谷区神宮前6-20-10',
  description_ja = '渋谷駅至近の宮下パーク複合施設屋上にある有料のプレミアムスケートパーク。Nike協力のもと、プロのポール・ロドリゲスとランス・マウンテンがデザインに関与。コンクリートボウル、7段含むステア、レール、レッジ、マニュアル台などを備え、クラブハウスでヘルメット無料貸出（着用必須）。',
  history_ja = '1953年開園の宮下公園が、三井不動産と渋谷区の再開発で2020年6月に立体複合施設として再オープン。スケート施設はプロ監修で話題となり、Nikeとの協業でも注目を集めました。',
  facilities_ja = 'スムーズなコンクリートボウル、7段ステア、その他ステア、レール、レッジ、マニュアル台、ヘルメット貸出',
  surface_type_ja = '高品質コンクリート',
  closed_days_ja = '年末年始',
  admission_fee_ja = '大人2時間200円／学生2時間100円（変更の場合あり）'
WHERE slug = 'miyashita-park-skatepark';

UPDATE skateparks SET
  city_ja = '荒川区',
  address_ja = '〒116-0003 東京都荒川区南千住4-2-3',
  description_ja = '東京メトロ日比谷線高架直下にある屋内スケートパーク兼スクール。延床約300㎡、高さ650・800・1200mmのミニランプ3基と、ボックス・レール付きフラットエリア。会員制オンライン予約とスマートロック入館。ボード・ヘルメット・プロテクター無料レンタル。5歳からのレッスンあり。',
  history_ja = 'スケート施設が少なかった南千住・荒川周辺向けに開業。高架下のデッドスペース活用モデルとして、雨天・猛暑に強い屋内練習場として定着しています。',
  facilities_ja = 'ミニランプ3（H650/800/1200）、フラット＋ボックス・レール、無料レンタル',
  surface_type_ja = '滑らかなコンクリート',
  closed_days_ja = '施設・サイトで要確認',
  admission_fee_ja = '有料（レッスン・フリースケ等、サイト参照）'
WHERE slug = 'ramp-zero';

UPDATE skateparks SET
  city_ja = '渋谷区',
  address_ja = '〒151-0052 東京都渋谷区代々木神園町1-1-1',
  description_ja = '代々木公園内の無料屋外アーバンスポーツエリア。フラットとボックス中心のシンプルな構成で、基礎練習や初心者に向きます。原宿・渋谷に近く、緑地に囲まれた落ち着いた環境です。',
  history_ja = '公園の地は元ワシントンハイツおよび1964年選手村跡地で、1967年に都立公園として開園。ハラジュク方面のスケート需要に応じてアーバンスポーツエリアが後年整備され、今後の区画改修も計画されています。',
  facilities_ja = 'フラットエリア、ボックス系セクション',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'yoyogi-park-urban-sports-park';

UPDATE skateparks SET
  city_ja = '品川区',
  address_ja = '〒140-0001 東京都品川区八潮1-3-1',
  description_ja = '東京湾岸の八潮地区、品川シーサイド駅からアクセスできる屋外スケボー場。ボックス、カーブレッジ、アーク、バンク、ダウンレールなどストリート系が充実。初心者向けスクールが毎月第4土曜に開かれることもあります。',
  history_ja = '埋立て地を含む八潮の公園整備の一環として品川区が整備。湾岸の住宅・業務エリアにスケートの拠点を提供しています。',
  facilities_ja = 'ボックス、カーブレッジ、アーク、バンク、ダウンレール',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '大人400円／日、学生200円／日（品川区民は割引）'
WHERE slug = 'yashio-kita-park-skatepark';

UPDATE skateparks SET
  city_ja = '江東区',
  address_ja = '〒135-0064 東京都江東区青海1-1-10',
  description_ja = 'お台場青海エリアの屋外スケート・アーバンスポーツ施設（H.L.N.A運営）。東京湾・お台場の眺望と、カーブレッジ、マニュアル台、アーク、バンク、ランプ、ステア、ダウンレール・レッジなど多彩なセクション。女子・大人向けスクールや年会費制の会員カード制度あり。',
  history_ja = 'お台場の再開発とともに整備された商業系屋外パークの一つ。エナジードリンクRAIZINとのネーミング協業でも知られ、オリンピック後のスケート人気とともに利用が広がりました。',
  facilities_ja = 'カーブレッジ、マニュアル台、アーク、バンク、ランプ、ステア、ダウンレール、ダウンレッジ',
  surface_type_ja = '滑らかなコンクリート',
  closed_days_ja = '施設・サイトで要確認',
  admission_fee_ja = '時間制・年会費あり（サイト参照）'
WHERE slug = 'raizin-sky-garden';

UPDATE skateparks SET
  city_ja = '大田区',
  address_ja = '〒143-0016 東京都大田区大森北3-39-5 B1',
  description_ja = '大森北のビル地下にあるコンパクトな屋内ランプパーク。大・中・小の3ランプは緩やかなアールで幅広いトリに向く設計。平和島・大森海岸駅からアクセス。店主「ばばちゃん」の人柄でも知られるローカル向けスポット。',
  history_ja = '大田区南部の住宅・工業地帯で屋内施設が不足していたエリア向けに開業。ランプ特化でトランジション練習に適しています。',
  facilities_ja = '大・中・小ランプ',
  surface_type_ja = '木材・コンクリート',
  closed_days_ja = 'Instagram等で要確認',
  admission_fee_ja = '1時間1,000円（延長15分100円）、初回登録500円'
WHERE slug = 'the-yago-skateboard-park';

UPDATE skateparks SET
  city_ja = '豊島区',
  address_ja = '〒170-0013 東京都豊島区東池袋1-44-15',
  description_ja = '池袋大橋高架下の無料屋外パーク。夏の日陰や小雨時の利用に有利。カーブ、マニュアル台、アーク、バンクなど中級未満のストリート向き。利用には約1km離れたHIGHSOX SKATE SHOPでリストバンド取得が必要。',
  history_ja = '以前は池袋駅前公園にあった施設が、高架下に移設・拡張されました。山手線北側で数少ない無料公園パークの一つです。',
  facilities_ja = 'カーブレッジ、マニュアル台、アーク、バンク',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料（HIGHSOXでリストバンド必須）'
WHERE slug = 'ikebukuro-skatepark';

UPDATE skateparks SET
  city_ja = '世田谷区',
  address_ja = '〒157-0062 東京都世田谷区上祖師谷3-22-19',
  description_ja = '祖師谷公園内のコミュニティ主導型屋外スポット。ボックス、レール、バンク、アーク、ランプなどは地元スケーターがDIYで整備・維持するスタイル。緑の多い公園で雰囲気が良く、訪問者にも開放的な現場です。',
  history_ja = '祖師谷・喜多見エリアのスケーターが公園内に段階的にセクションを作り、自主管理してきました。時間は固定せず、SNS等で確認する必要があります。',
  facilities_ja = 'ボックス、レール、バンク、アーク、ランプ（DIY・コミュニティ維持）',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '不定',
  admission_fee_ja = '無料'
WHERE slug = 'soshigaya-park-skatepark';

UPDATE skateparks SET
  city_ja = '板橋区',
  address_ja = '〒173-0004 東京都板橋区板橋1-48-8 ダイアパレス新板橋 B1',
  description_ja = '新板橋のマンション地下にある屋内パーク＆カフェ。ボックス、マニュアル台、バンク、ランプ、ボウルを備え、段階的に技を積み上げやすいレイアウトで評価。13歳未満はヘルメット必須、大人は任意。',
  history_ja = '都心北部では屋内施設が限られる中、板橋区で地下室スペースを活用して開業。セッション後のカフェで交流できるスタイルが特徴です。',
  facilities_ja = 'ボックス、マニュアル台、バンク、ランプ、ボウル、カフェ',
  surface_type_ja = 'コンクリート・木材',
  closed_days_ja = '施設・サイトで要確認',
  admission_fee_ja = '一般2時間1,000円〜、女性・18歳未満割引、初回登録1,000円（要確認）'
WHERE slug = 'diorama-skate-lounge';

UPDATE skateparks SET
  city_ja = '足立区',
  address_ja = '〒121-0833 東京都足立区宮城2-2',
  description_ja = '宮城ファミリー公園内のDIY中心スポット。都電荒川線小台駅近く。ボックス、マニュアル台、アーク、フラットレール、コーン等を地元が手作り・維持。無料・登録不要・ヘルメット非義務で敷居が低い東部23区の貴重な場所です。',
  history_ja = '足立区では公設パークが少ない中、公園内にコミュニティがセクションを作り広げてきた例です。',
  facilities_ja = 'ボックス、マニュアル台、アーク、フラットレール、コーン（DIY）',
  surface_type_ja = 'アスファルト・コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'adachi-miyagi-family-park';

UPDATE skateparks SET
  city_ja = '足立区',
  address_ja = '〒123-0864 東京都足立区島根4-12',
  description_ja = '西新井方面の島根にある超コンパクトな予約制屋内パーク。標準と初心者向けの2つのミニランプでランプ練習に特化。電話予約のみ。東部での手頃な屋内トランジション練習場として利用されています。',
  history_ja = '足立区西部で屋内施設の空白を埋める形で開業。定員管理のため完全予約制です。',
  facilities_ja = 'ミニランプ（標準・小）',
  surface_type_ja = 'コンクリート・木材',
  closed_days_ja = '要確認',
  admission_fee_ja = '2時間500円（延長1時間200円）'
WHERE slug = '8times-corner-store';

UPDATE skateparks SET
  city_ja = '板橋区',
  address_ja = '〒175-0082 東京都板橋区舟渡4-12-20',
  description_ja = '板橋区西北部・舟渡の倉庫型ビル地下にある大規模屋内パーク。ボックス、レール、アーク、バンク、バンクツーバンク、移動可能オバケとプロショップTRINITY併設。月例スクールあり。18歳未満はヘルメット必須。',
  history_ja = 'TRINITYブランドの店舗一体型として、板橋北西部の滑り手コミュニティのハブになっています。',
  facilities_ja = 'ボックス、レール、アーク、バンク、バンクツーバンク、ランプ、可動式障害物、隣接プロショップ',
  surface_type_ja = 'コンクリート・木材',
  closed_days_ja = 'サイト要確認',
  admission_fee_ja = '一般3時間1,100円または終日1,500円、12歳以下割引（サイト参照）'
WHERE slug = 'trinity-b3-park';

UPDATE skateparks SET
  city_ja = '江東区',
  address_ja = '〒136-0081 東京都江東区夢の島1-1',
  description_ja = '夢の島（埋立ゴミ地を緑化した人工島）にある都屈指の規模の公設屋外パーク。2022年11月開業。初心者ゾーンと中上級ゾーンに分かれ、バーティカルを含む多彩な障害物を備えます。堀米雄斗選手にちなみ「堀米パーク」の通称でも親しまれます。',
  history_ja = '東京2020でスケートがオリンピック種目になった流れで、夢の島の公園整備の一環として開業。メダリストの影響で国内のスケート人気が高まる中、象徴的な施設となりました。',
  facilities_ja = '初心者・中上級エリア、カーブレッジ、マニュアル台、レール、バンク、ステア、ミニランプ、バーティカル等',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし（管理棟でリストバンド取得）',
  admission_fee_ja = '大人450円／日、中高生150円／日（要確認）'
WHERE slug = 'yumenoshima-skateboard-park';

UPDATE skateparks SET
  city_ja = '墨田区',
  address_ja = '〒131-0033 東京都墨田区堤通1-8-1',
  description_ja = '堤通公園内・高架下の暫定ストリートスポット。曳舟・東向島方面。ボックス、レール、バンクのみのシンプル構成。雨を多少しのげる。常設化を目指し、利用後の片付けとマナーが継続の鍵とされています。',
  history_ja = '墨田区では公設パークが少ない中、線路下空間をコミュニティが活用する形で生まれました。公式な常設施設ではない点に注意が必要です。',
  facilities_ja = 'ボックス、レール、バンク',
  surface_type_ja = 'アスファルト',
  closed_days_ja = '不定',
  admission_fee_ja = '無料'
WHERE slug = 'tsutsumidori-park-skatepark';

UPDATE skateparks SET
  city_ja = '横須賀市',
  address_ja = '〒238-0013 神奈川県横須賀市平成町3-23',
  description_ja = '海辺のうみかぜ公園内、延床約3,400㎡超の大型公設屋外パーク。日本スケート史上有名で多くのプロを輩出。ボウル、ミニランプ、クォーター、スパイン、ピラミッド、レール、レッジ、バンク、ステア、広いフラット、夜間照明あり。2018年3月に全面改修。',
  history_ja = '1996年、横須賀市の東京湾岸開発の一環として開園。長年の使用で老朽化したため2018年にリニューアルし、現行の高品質コンクリート面となりました。',
  facilities_ja = 'ボウル、ミニランプ、クォーター、スパイン、ピラミッド、レール、レッジ、バンク、カーブ、マニュアル台、ステア、フラット、照明',
  surface_type_ja = '全天候型コーティングのコンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'umikaze-park-skatepark';
