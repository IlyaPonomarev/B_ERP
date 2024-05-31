//
//#Область СлужебныеПроцедурыИФункции
//
////@skip-warning
//&ИзменениеИКонтроль("ОтразитьОперациюСебестоимостиРеализация")
//Процедура RA_AdditionalFields_ОтразитьОперациюСебестоимостиРеализация(ПараметрыОтражения)
//
//	// Сформируем шаблон текста запроса для отражения операции.
//	ТекстЗапросаОтражения =
//	"ВЫБРАТЬ
//	|	ДанныеДокумента.НомерОперации КАК НомерОперации,
//	// Описание документа
//	|	ВЫБОР
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровОтКлиентаПрошлыхПериодов))
//	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровЧерезКомиссионераПрошлыхПериодов))
//	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
//	//++ НЕ УТКА
//
//	//++ Устарело_Переработка24
//	|		КОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) = ТИП(Документ.ОтчетДавальцу)
//	|		  И ДанныеДокумента.ВидДеятельностиНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
//	|		  И (НЕ &Константа_ПартионныйУчетВерсии22
//	|		  		ИЛИ ДанныеДокумента.Период < НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ))
//	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
//	//-- Устарело_Переработка24
//
//	//-- НЕ УТКА
//	|			ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
//	|	КОНЕЦ									КАК ВидДвижения,
//	|	ДанныеДокумента.Период 					КАК Период,
//	|
//	// Поля учета номенклатуры
//	|	ДанныеДокумента.Организация 															КАК Организация,
//	|	ЕСТЬNULL(ВТАналитикиНоменклатуры.АналитикаУчетаНоменклатуры, НЕОПРЕДЕЛЕНО) 				КАК АналитикаУчетаНоменклатуры,
//	|	ЕСТЬNULL(ВТАналитикиНоменклатуры.АналитикаУчетаНоменклатурыИсходная, НЕОПРЕДЕЛЕНО) 		КАК АналитикаУчетаНоменклатурыИсходная,
//	|	ДанныеДокумента.ВидЗапасов 																КАК ВидЗапасов,
//	|	ВЫБОР
//	|		КОГДА ДанныеДокумента.ЕстьПолеЗапроса_РазделУчета
//	|			ТОГДА ДанныеДокумента.РазделУчета
//	|		КОГДА РазделыУчета.Расчетное_РазделУчета <> НЕОПРЕДЕЛЕНО
//	|			ТОГДА РазделыУчета.Расчетное_РазделУчета
//	|		КОГДА ДанныеДокумента.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
//	|		  ИЛИ ДанныеДокумента.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)
//	//++ НЕ УТКА
//
//	//++ Устарело_Переработка24
//	|		КОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) = ТИП(Документ.ОтчетДавальцу)
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)
//	//-- Устарело_Переработка24
//
//	//-- НЕ УТКА
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеНедостачЗаСчетПоклажедателя))
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыПереданныеПартнерам)
//	//++ НЕ УТ
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеТоваровУПереработчика))
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеПереработчику)
//	//-- НЕ УТ
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтчетКомиссионера),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеИзлишковТоваровВПользуКомитента),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеНедостачЗаСчетКомитента),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера))
//	|		  И ДанныеДокумента.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеНаКомиссию)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В(
//	|		  ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтгрузкаПринятыхСПравомПродажиТоваровСХранения),
//	|		  ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоставкаПодПринципала))
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаХраненииСПравомПродажи)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В(
//	//++ Устарело_Переработка24
//	|		  ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаДавальцу),
//	//-- Устарело_Переработка24
//	|		  ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыкупТоваровДавальца))
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаОтветхранение)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыкупПринятыхНаХранениеТоваров))
//	|			ТОГДА
//	|				ВЫБОР КОГДА ДанныеДокумента.АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
//	|					ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаХраненииСПравомПродажиПереданныеПартнерам)
//	|					ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаХраненииСПравомПродажи)
//	|				КОНЕЦ
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыкупТоваровХранителем),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыкупТоваровПереработчиком))
//	|			ТОГДА
//	|				ВЫБОР
//	|					КОГДА ДанныеДокумента.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.ТоварНаХраненииСПравомПродажи)
//	|						ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаХраненииСПравомПродажиПереданныеПартнерам)
//	|					КОГДА ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыкупТоваровПереработчиком)
//	|						ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеПереработчику)
//	|						ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.СобственныеТоварыПереданныеПартнерам)
//	|				КОНЕЦ
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности))
//	|			И ДанныеДокумента.ВидЗапасов.ТипЗапасов <> ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеНаКомиссиюВПути)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности))
//	|			И ДанныеДокумента.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссиюВПути)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности))
//	|		  И ДанныеДокумента.ВидЗапасов.ТипЗапасов <> ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыВПути)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности))
//	|		  И ДанныеДокумента.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссиюВПути)
//	|		КОГДА ДанныеДокумента.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссию)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперацияДокумента В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровЧерезКомиссионера))
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПереданныеНаКомиссию)
//	|		КОГДА ДанныеДокумента.АналитикаУчетаНоменклатуры.СкладскаяТерритория.ЦеховаяКладовая
//	|		  ИЛИ ДанныеДокумента.АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Подразделение)
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)
//	|			ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах)
//	|	КОНЕЦ 																					КАК РазделУчета,
//	|
//	// Корреспондирующие поля
//	|	ВЫБОР
//	|		КОГДА ДанныеДокумента.ЕстьПолеЗапроса_КорРазделУчета
//	|			ТОГДА ДанныеДокумента.КорРазделУчета
//	|		КОГДА РазделыУчета.Расчетное_КорРазделУчета <> НЕОПРЕДЕЛЕНО
//	|			ТОГДА РазделыУчета.Расчетное_КорРазделУчета
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию))
//	|			ТОГДА ВЫБОР
//	|				КОГДА ЕСТЬNULL(ВТКорАналитикиНоменклатуры.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры, НЕОПРЕДЕЛЕНО)
//	|						= ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
//	|					ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)
//	|				КОГДА ДанныеДокумента.АналитикаУчетаНоменклатуры.СкладскаяТерритория.ЦеховаяКладовая
//	|		  		  ИЛИ ДанныеДокумента.АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Подразделение)
//	|					ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)
//	|					ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах)
//	|				КОНЕЦ
//	|			ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 																					КАК КорРазделУчета,
//	|	ДанныеДокумента.КорОрганизация 															КАК КорОрганизация,
//	|	ЕСТЬNULL(ВТКорАналитикиНоменклатуры.АналитикаУчетаНоменклатуры, НЕОПРЕДЕЛЕНО) 			КАК КорАналитикаУчетаНоменклатуры,
//	|	ЕСТЬNULL(ВТКорАналитикиНоменклатуры.АналитикаУчетаНоменклатурыИсходная, НЕОПРЕДЕЛЕНО) 	КАК КорАналитикаУчетаНоменклатурыИсходная,
//	|	ДанныеДокумента.КорВидЗапасов 															КАК КорВидЗапасов,
//	|
//	// Прочие поля
//	|	(ВЫБОР
//	|		КОГДА ДанныеДокумента.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
//	|		 И ДанныеДокумента.ХозяйственнаяОперация В (
//	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту),
//	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияВРозницу))
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКомиссионногоТовара)
//	|		ИНАЧЕ ДанныеДокумента.ХозяйственнаяОперация КОНЕЦ) КАК ХозяйственнаяОперация,
//	|	ДанныеДокумента.АналитикаУчетаПоПартнерам 	КАК АналитикаУчетаПоПартнерам,
//	#Удаление
//	|	ДанныеДокумента.Подразделение 				КАК Подразделение,
//	#КонецУдаления
//	#Вставка
//	|	ДанныеДокумента.АналитикаУчетаНоменклатуры.Номенклатура.RA_AdditionalFields_ProfitCentre КАК Подразделение,
//	#КонецВставки
//	|	ДанныеДокумента.ЗаказКлиента 				КАК ЗаказКлиента,
//	|	ДанныеДокумента.ПериодДокументаИсточника	КАК ПериодПродажи,
//	|
//	// Количественные и суммовые показатели
//	|	ДанныеДокумента.Количество 					КАК Количество,
//	|	ВЫБОР КОГДА ДанныеДокумента.ЕстьПолеЗапроса_СтоимостьЗабалансовая
//	|		ТОГДА ДанныеДокумента.СтоимостьЗабалансовая
//	|		ИНАЧЕ 0
//	|	КОНЕЦ 										КАК СтоимостьЗабалансовая,
//	|	ВЫБОР КОГДА ДанныеДокумента.ЕстьПолеЗапроса_СтоимостьЗабалансоваяРегл
//	|		ТОГДА ДанныеДокумента.СтоимостьЗабалансоваяРегл
//	|		ИНАЧЕ 0
//	|	КОНЕЦ 										КАК СтоимостьЗабалансоваяРегл,
//	|
//	// Поля партионного учета версии 2.2
//	|	ВЫБОР
//	|		КОГДА НЕ &Константа_ПартионныйУчетВерсии22
//	|		  ИЛИ ДанныеДокумента.Период < НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|			ТОГДА НЕОПРЕДЕЛЕНО
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности))
//	|	  	  И УчетныеПолитикиОрганизаций.ФИФОСкользящаяОценка
//	|			ТОГДА ДанныеДокумента.Ссылка
//	|			ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 														  КАК Партия,
//	|	ВЫБОР КОГДА &Константа_ПартионныйУчетВерсии22
//	|	  И ДанныеДокумента.Период >= НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
////	|	  И НЕ УчетныеПолитикиОрганизаций.ФИФОСкользящаяОценка
//	|		И ЕСТЬNULL(КорУчетныеПолитикиОрганизаций.ФИФОСкользящаяОценка, ИСТИНА) = ИСТИНА
//	|		ТОГДА ДанныеДокумента.КорАналитикаУчетаПартий
//	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 														  КАК КорАналитикаУчетаПартий,
//	|	ВЫБОР
//	|		КОГДА НЕ &Константа_ПартионныйУчетВерсии22
//	|		  ИЛИ ДанныеДокумента.Период < НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|			ТОГДА НЕОПРЕДЕЛЕНО
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности))
//	|		  И ДанныеДокумента.ВидЗапасов.ТипЗапасов <> ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
//	|			ТОГДА ВТАналитикиФинансовогоУчета.АналитикаФинансовогоУчета
//	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 														  КАК АналитикаФинансовогоУчета,
//	|	ВЫБОР КОГДА &Константа_ПартионныйУчетВерсии22
//	|	  И ДанныеДокумента.Период >= НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|	  И (ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) = ТИП(Документ.РеализацияТоваровУслуг)
//	|		 И ДанныеДокумента.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа))
//	|		ТОГДА ВТАналитикиФинансовогоУчета.АналитикаФинансовогоУчета
//	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 														  КАК КорАналитикаФинансовогоУчета,
//	|	ВЫБОР
//	|		КОГДА НЕ &Константа_ПартионныйУчетВерсии22
//	|		  ИЛИ ДанныеДокумента.Период < НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|			ТОГДА НЕОПРЕДЕЛЕНО
//	|		КОГДА НЕ ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности))
//	|			ТОГДА НЕОПРЕДЕЛЕНО
//	|		ИНАЧЕ ДанныеДокумента.ВидДеятельностиНДС
//	|	КОНЕЦ 														  КАК ВидДеятельностиНДС,
//	|	ВЫБОР
//	|		КОГДА ДанныеДокумента.ЕстьПолеЗапроса_КорВидДеятельностиНДС
//	|			ТОГДА ДанныеДокумента.КорВидДеятельностиНДС
//	|		ИНАЧЕ ДанныеДокумента.ВидДеятельностиНДС
//	|	КОНЕЦ							 							  КАК КорВидДеятельностиНДС,
//	|	ВЫБОР КОГДА &Константа_ПартионныйУчетВерсии22
//	|	  И ДанныеДокумента.Период >= НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|		И ЕСТЬNULL(КорУчетныеПолитикиОрганизаций.ФИФОСкользящаяОценка, ИСТИНА) = ИСТИНА
//	|		ТОГДА ДанныеДокумента.КорПартия
//	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 														  КАК КорПартия,
//	|	ВЫБОР КОГДА &Константа_ПартионныйУчетВерсии22
//	|	  И ДанныеДокумента.Период >= НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|		ТОГДА ВТАналитикиФинансовогоУчета.АналитикаФинансовогоУчета
//	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 														  КАК АналитикаФинансовогоУчетаДокумента,
//	|	ВЫБОР КОГДА &Константа_ПартионныйУчетВерсии22
//	|	  И ДанныеДокумента.Период >= НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|		ТОГДА ДанныеДокумента.ВидДеятельностиНДСДокумента
//	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 														  КАК ВидДеятельностиНДСДокумента,
//	|
//	|	ВЫБОР
//	|		КОГДА ДанныеДокумента.ЕстьПолеЗапроса_ТипЗаписи
//	|			ТОГДА ДанныеДокумента.ТипЗаписи
//	//++ НЕ УТКА
//
//	//++ Устарело_Переработка24
//	|		КОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) = ТИП(Документ.ОтчетДавальцу)
//	|		  И ДанныеДокумента.ВидДеятельностиНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
//	|		  И (НЕ &Константа_ПартионныйУчетВерсии22
//	|		  		ИЛИ ДанныеДокумента.Период < НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ))
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.ПустаяСсылка)
//	//-- Устарело_Переработка24
//
//	//-- НЕ УТКА
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровОтКлиентаПрошлыхПериодов),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровЧерезКомиссионераПрошлыхПериодов))
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.ВозвратПрошлыхПериодов)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторноПереданнойТарыВозвратНаДругойСклад),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторноРеализацииВозвратНаДругойСклад))
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.СторноВозвратНаДругойСклад)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтчетКомиссионера))
//	|		  И ДанныеДокумента.Количество < 0
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.ВозвратБезДокументаИсточника)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация В
//	|		  (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторноПереданнойТары),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровЧерезКомиссионера),
//	|		   ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторноРеализации))
//	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.Сторно)
//	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация =
//	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности) ТОГДА
//	|			ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.ПотреблениеТоварыВПути)
//	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.Потребление)
//	|	КОНЕЦ														  КАК ТипЗаписи,
//	|	ЗНАЧЕНИЕ(Перечисление.ОперацииУчетаСебестоимости.Реализация)  КАК ОперацияУчетаСебестоимости,
//	|	ДанныеДокумента.ДокументИсточник 							  КАК ДокументИсточник,
//	|	ДанныеДокумента.ИдентификаторСтроки 						  КАК ИдентификаторСтроки,
//	|	ДанныеДокумента.ИдентификаторФинЗаписи 						  КАК ИдентификаторФинЗаписи,
//	|	(ВЫБОР
//	|		КОГДА ДанныеДокумента.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
//	|		 И ДанныеДокумента.ХозяйственнаяОперация В (
//	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту),
//	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияВРозницу))
//	|			ТОГДА ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.РеализацияКомиссионногоТовара)
//	|		ИНАЧЕ ДанныеДокумента.НастройкаХозяйственнойОперации КОНЕЦ) КАК НастройкаХозяйственнойОперации
//	|ПОМЕСТИТЬ ВТОперация_Реализация
//	|ИЗ
//	|	ВТДанныеДокумента КАК ДанныеДокумента
//	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаменаАналитикУчетаНоменклатуры КАК ВТАналитикиНоменклатуры
//	|		ПО ДанныеДокумента.АналитикаУчетаНоменклатуры = ВТАналитикиНоменклатуры.АналитикаУчетаНоменклатурыИсходная
//	|		И ДанныеДокумента.ВидЗапасов = ВТАналитикиНоменклатуры.ВидЗапасов
//	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаменаАналитикУчетаНоменклатуры КАК ВТКорАналитикиНоменклатуры
//	|		ПО ДанныеДокумента.КорАналитикаУчетаНоменклатуры = ВТКорАналитикиНоменклатуры.АналитикаУчетаНоменклатурыИсходная
//	|		И ДанныеДокумента.КорВидЗапасов = ВТКорАналитикиНоменклатуры.ВидЗапасов
//	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТАналитикиФинансовогоУчета КАК ВТАналитикиФинансовогоУчета
//	|		ПО ДанныеДокумента.Сделка = ВТАналитикиФинансовогоУчета.Сделка
//	|		И ДанныеДокумента.Менеджер = ВТАналитикиФинансовогоУчета.Менеджер
//	|		И ДанныеДокумента.Подразделение = ВТАналитикиФинансовогоУчета.Подразделение
//	|		И ДанныеДокумента.ГруппаПродукции = ВТАналитикиФинансовогоУчета.ГруппаПродукции
//	|		И ДанныеДокумента.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры = ВТАналитикиФинансовогоУчета.ТипНоменклатуры
//	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТУчетныеПолитикиОрганизаций КАК УчетныеПолитикиОрганизаций
//	|		ПО ДанныеДокумента.Организация = УчетныеПолитикиОрганизаций.Организация
//	|		И ДанныеДокумента.Период = УчетныеПолитикиОрганизаций.Период
//	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТУчетныеПолитикиОрганизаций КАК КорУчетныеПолитикиОрганизаций
//	|		ПО ДанныеДокумента.КорОрганизация = КорУчетныеПолитикиОрганизаций.Организация
//	|		И ДанныеДокумента.Период = КорУчетныеПолитикиОрганизаций.Период
//	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТРазделыУчета КАК РазделыУчета
//	|		ПО ДанныеДокумента.НомерЗаписи = РазделыУчета.НомерЗаписи
//	|ГДЕ
//	|	ДанныеДокумента.ОперацияУчетаСебестоимости = ЗНАЧЕНИЕ(Перечисление.ОперацииУчетаСебестоимости.Реализация)
//	|
//	|ОБЪЕДИНИТЬ ВСЕ
//	|
//	|ВЫБРАТЬ
//	|	ДанныеДокумента.НомерОперации КАК НомерОперации,
//	// Описание документа
//	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)	КАК ВидДвижения,
//	|	ДанныеДокумента.Период 					КАК Период,
//	|
//	// Поля учета номенклатуры
//	|	ДанныеДокумента.Организация 															КАК Организация,
//	|	ЕСТЬNULL(ВТКорАналитикиНоменклатуры.АналитикаУчетаНоменклатуры, НЕОПРЕДЕЛЕНО) 			КАК АналитикаУчетаНоменклатуры,
//	|	ЕСТЬNULL(ВТКорАналитикиНоменклатуры.АналитикаУчетаНоменклатурыИсходная, НЕОПРЕДЕЛЕНО) 	КАК АналитикаУчетаНоменклатурыИсходная,
//	|	ДанныеДокумента.КорВидЗапасов															КАК ВидЗапасов,
//	|	ВЫБОР
//	|		КОГДА ДанныеДокумента.ЕстьПолеЗапроса_КорРазделУчета
//	|			ТОГДА ДанныеДокумента.КорРазделУчета
//	|		КОГДА РазделыУчета.Расчетное_КорРазделУчета <> НЕОПРЕДЕЛЕНО
//	|			ТОГДА РазделыУчета.Расчетное_КорРазделУчета
//	|			ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 																					КАК РазделУчета,
//	|
//	// Корреспондирующие поля
//	|	НЕОПРЕДЕЛЕНО																			КАК КорРазделУчета,
//	|	НЕОПРЕДЕЛЕНО																			КАК КорОрганизация,
//	|	НЕОПРЕДЕЛЕНО																			КАК КорАналитикаУчетаНоменклатуры,
//	|	НЕОПРЕДЕЛЕНО																			КАК КорАналитикаУчетаНоменклатурыИсходная,
//	|	НЕОПРЕДЕЛЕНО																			КАК КорВидЗапасов,
//	|
//	// Прочие поля
//	|	ДанныеДокумента.ХозяйственнаяОперация		КАК ХозяйственнаяОперация,
//	|	НЕОПРЕДЕЛЕНО								КАК АналитикаУчетаПоПартнерам,
//	|	ДанныеДокумента.Подразделение 				КАК Подразделение,
//	|	НЕОПРЕДЕЛЕНО								КАК ЗаказКлиента,
//	|	НЕОПРЕДЕЛЕНО								КАК ПериодПродажи,
//	|
//	// Количественные и суммовые показатели
//	|	ДанныеДокумента.Количество 					КАК Количество,
//	|	0	 										КАК СтоимостьЗабалансовая,
//	|	0											КАК СтоимостьЗабалансоваяРегл,
//	|
//	// Поля партионного учета версии 2.2
//	|	НЕОПРЕДЕЛЕНО													КАК Партия,
//	|	НЕОПРЕДЕЛЕНО													КАК КорАналитикаУчетаПартий,
//	|	НЕОПРЕДЕЛЕНО													КАК АналитикаФинансовогоУчета,
//	|	ВЫБОР КОГДА &Константа_ПартионныйУчетВерсии22
//	|	  И ДанныеДокумента.Период >= НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|	  И (ТИПЗНАЧЕНИЯ(ДанныеДокумента.Ссылка) = ТИП(Документ.РеализацияТоваровУслуг)
//	|		 И ДанныеДокумента.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа))
//	|		ТОГДА ВТАналитикиФинансовогоУчета.АналитикаФинансовогоУчета
//	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 															КАК КорАналитикаФинансовогоУчета,
//	|	ВЫБОР
//	|		КОГДА НЕ &Константа_ПартионныйУчетВерсии22
//	|		  ИЛИ ДанныеДокумента.Период < НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|			ТОГДА НЕОПРЕДЕЛЕНО
//	|		ИНАЧЕ ДанныеДокумента.ВидДеятельностиНДС
//	|	КОНЕЦ 															КАК ВидДеятельностиНДС,
//	|	НЕОПРЕДЕЛЕНО							 						КАК КорВидДеятельностиНДС,
//	|	НЕОПРЕДЕЛЕНО 													КАК КорПартия,
//	|	ВЫБОР КОГДА &Константа_ПартионныйУчетВерсии22
//	|	  И ДанныеДокумента.Период >= НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|		ТОГДА ВТАналитикиФинансовогоУчета.АналитикаФинансовогоУчета
//	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 															КАК АналитикаФинансовогоУчетаДокумента,
//	|	ВЫБОР КОГДА &Константа_ПартионныйУчетВерсии22
//	|	  И ДанныеДокумента.Период >= НАЧАЛОПЕРИОДА(&Константа_ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
//	|		ТОГДА ДанныеДокумента.ВидДеятельностиНДСДокумента
//	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
//	|	КОНЕЦ 															КАК ВидДеятельностиНДСДокумента,
//	|
//	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.Перемещение)			КАК ТипЗаписи,
//	|	ЗНАЧЕНИЕ(Перечисление.ОперацииУчетаСебестоимости.Реализация)	КАК ОперацияУчетаСебестоимости,
//	|	ДанныеДокумента.Ссылка 											КАК ДокументИсточник,
//	|	ДанныеДокумента.ИдентификаторСтроки 							КАК ИдентификаторСтроки,
//	// Для прихода давальческой продукции идентификатор фин записи не заполняем, т.к. у давальческой продукции нет балансовой стоимости.
//	|	&ИдентификаторНеиспользуемойФинЗаписи 							КАК ИдентификаторФинЗаписи,
//	|	ДанныеДокумента.НастройкаХозяйственнойОперации					КАК НастройкаХозяйственнойОперации
//	|ИЗ
//	|	ВТДанныеДокумента КАК ДанныеДокумента
//	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаменаАналитикУчетаНоменклатуры КАК ВТКорАналитикиНоменклатуры
//	|		ПО ДанныеДокумента.КорАналитикаУчетаНоменклатуры = ВТКорАналитикиНоменклатуры.АналитикаУчетаНоменклатурыИсходная
//	|		И ДанныеДокумента.КорВидЗапасов = ВТКорАналитикиНоменклатуры.ВидЗапасов
//	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТАналитикиФинансовогоУчета КАК ВТАналитикиФинансовогоУчета
//	|		ПО ДанныеДокумента.Сделка = ВТАналитикиФинансовогоУчета.Сделка
//	|		И ДанныеДокумента.Менеджер = ВТАналитикиФинансовогоУчета.Менеджер
//	|		И ДанныеДокумента.Подразделение = ВТАналитикиФинансовогоУчета.Подразделение
//	|		И ДанныеДокумента.ГруппаПродукции = ВТАналитикиФинансовогоУчета.ГруппаПродукции
//	|		И ДанныеДокумента.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры = ВТАналитикиФинансовогоУчета.ТипНоменклатуры
//	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТРазделыУчета КАК РазделыУчета
//	|		ПО ДанныеДокумента.НомерЗаписи = РазделыУчета.НомерЗаписи
//	|ГДЕ
//	|	ДанныеДокумента.ОперацияУчетаСебестоимости = ЗНАЧЕНИЕ(Перечисление.ОперацииУчетаСебестоимости.Реализация)
//	|	И ЕСТЬNULL(ДанныеДокумента.КорВидЗапасов.ТипЗапасов, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.ПродукцияДавальца)
//	|	И ЕСТЬNULL(ДанныеДокумента.ВидЗапасов.ТипЗапасов, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.ПолуфабрикатДавальца)
//	|";
//
//	ПараметрыОтражения.ТекстыШаблоновВТ.Вставить("ВТОперация_Реализация", ТекстЗапросаОтражения);
//
//КонецПроцедуры
//#КонецОбласти