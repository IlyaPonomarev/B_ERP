

#Область СлужебныеПроцедурыИФункции

//@skip-check method-text-has-differences-base-method
//@skip-check bsl-legacy-check-method-for-statements-after-return
&ИзменениеИКонтроль("ТекстСебестоимостьРеализованногоТовара")
Функция RA_AdditionalFields_ТекстСебестоимостьРеализованногоТовара()

	ТекстыЗапроса = Новый Массив;

#Область СебестоимостьРеализованногоТовара // (Дт 90.02.1 :: Кт 41.01, 45.01)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Себестоимость реализованного товара (Дт 90.02.1 :: Кт 41.01, 45.01)
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(Стоимости.Сумма, Строки.Сумма) КАК Сумма,
	|	ЕСТЬNULL(Стоимости.СуммаУУ, Строки.СуммаУУ) КАК СуммаУУ,
	|
	|	ВЫБОР КОГДА Операция.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД)
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.СебестоимостьПродажЕНВД)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.СебестоимостьПродаж)
	|	КОНЕЦ КАК ВидСчетаДт,
	|	Строки.ГруппаФинансовогоУчета КАК АналитикаУчетаДт,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.Склад) = ТИП(Справочник.Склады)
	|			ТОГДА Строки.Склад
	|		ИНАЧЕ
	|			НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	#Удаление
	|	Операция.Подразделение КАК ПодразделениеДт,
	#КонецУдаления
	#Вставка
	|	Строки.Номенклатура.RA_AdditionalFields_ProfitCentre КАК ПодразделениеДт,
	#КонецВставки
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	Строки.ГруппаФинансовогоУчета КАК СубконтоДт1,
	|	Строки.Номенклатура КАК СубконтоДт2,
	|	ЕСТЬNULL(ТаблицаНалогообложенияПрибыли.ВариантНалогообложенияПрибыли, НЕОПРЕДЕЛЕНО) КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	Строки.Количество КАК КоличествоДт,
	|	ЕСТЬNULL(Стоимости.СуммаНУ, Строки.СуммаНУ) КАК СуммаНУДт,
	|	ЕСТЬNULL(Стоимости.СуммаПР, Строки.СуммаПР) КАК СуммаПРДт,
	|	ЕСТЬNULL(Стоимости.СуммаВР, Строки.СуммаВР) КАК СуммаВРДт,
	|
	|	ВЫБОР
	|		КОГДА Операция.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера)
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.НоменклатураПереданная)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.НаСкладе)
	|	КОНЕЦ КАК ВидСчетаКт,
	|	Строки.ГруппаФинансовогоУчета КАК АналитикаУчетаКт,
	|	Строки.Склад КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Строки.ПодразделениеАналитики КАК ПодразделениеКт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	Строки.Номенклатура КАК СубконтоКт1,
	|	Строки.Склад КАК СубконтоКт2,
	|	Операция.Контрагент КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	ЕСТЬNULL(Стоимости.СуммаНУ, Строки.СуммаНУ) КАК СуммаНУКт,
	|	ЕСТЬNULL(Стоимости.СуммаПР, Строки.СуммаПР) КАК СуммаПРКт,
	|	ЕСТЬNULL(Стоимости.СуммаВР, Строки.СуммаВР) КАК СуммаВРКт,
	|	""Себестоимость реализованного товара"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РеализацияТоваровУслуг КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСтроки КАК Строки
	|	ПО
	|		Операция.Ссылка = Строки.Ссылка
	|		И Строки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтСтоимости КАК Стоимости
	|	ПО
	|		Строки.Ссылка = Стоимости.Ссылка
	|		И Строки.Номенклатура = Стоимости.Номенклатура
	|		И Строки.Склад = Стоимости.Склад
	|		И Строки.ГруппаФинансовогоУчета = Стоимости.ГруппаФинансовогоУчета
	|		И Строки.НаправлениеДеятельности = Стоимости.НаправлениеДеятельности
	|		И Строки.РазделУчета = Стоимости.РазделУчета
	|		И Строки.НастройкаХозяйственнойОперации = Стоимости.НастройкаХозяйственнойОперации
	|		И Строки.ИдентификаторФинЗаписи = Стоимости.ИдентификаторФинЗаписи
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РаздельныйУчет_НастройкиНалогообложенияПрибыли КАК ТаблицаНалогообложенияПрибыли
	|	ПО
	|		ТаблицаНалогообложенияПрибыли.Период = Операция.Дата
	|		И ТаблицаНалогообложенияПрибыли.Организация = Операция.Организация
	|		И ТаблицаНалогообложенияПрибыли.Подразделение = Операция.Подразделение
	|		И ТаблицаНалогообложенияПрибыли.ОбъектУчета = Строки.Номенклатура
	|		И ТаблицаНалогообложенияПрибыли.НаправлениеДеятельности = Операция.НаправлениеДеятельности
	|ГДЕ
	|	Операция.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.КПредоплате)
	|	И Строки.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|	И Строки.РазделУчета <> ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссию)
	|	И Строки.РазделУчета <> ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)
	|	И Операция.ХозяйственнаяОперация В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиентуРеглУчет),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера))
	|	И (
	|		ВЫБОР КОГДА Операция.ВернутьМногооборотнуюТару ТОГДА
	|			Строки.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ИНАЧЕ
	|			ИСТИНА
	|		КОНЕЦ)
	|";
	ТекстыЗапроса.Добавить(ТекстЗапроса);	
#КонецОбласти
	
//@skip-check module-structure-top-region
#Область СебестоимостьРеализованногоТовараСкладПроизводства // (Дт 90.02.1 :: Кт 20)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Себестоимость реализованного товара на складе производства (Дт 90.02.1 :: Кт 20)
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(Стоимости.СуммаБалансовая, Строки.СуммаБалансовая) КАК Сумма,
	|	ЕСТЬNULL(Стоимости.СуммаБалансоваяУУ, Строки.СуммаБалансоваяУУ) КАК СуммаУУ,
	|
	|	ВЫБОР КОГДА Операция.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД)
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.СебестоимостьПродажЕНВД)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.СебестоимостьПродаж)
	|	КОНЕЦ КАК ВидСчетаДт,
	|	Строки.ГруппаФинансовогоУчета КАК АналитикаУчетаДт,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Строки.Склад) = ТИП(Справочник.Склады)
	|			ТОГДА Строки.Склад
	|		ИНАЧЕ
	|			НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	Строки.ГруппаФинансовогоУчета КАК СубконтоДт1,
	|	Строки.Номенклатура КАК СубконтоДт2,
	|	ЕСТЬNULL(ТаблицаНалогообложенияПрибыли.ВариантНалогообложенияПрибыли, НЕОПРЕДЕЛЕНО) КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	Строки.Количество КАК КоличествоДт,
	|	ЕСТЬNULL(Стоимости.СуммаНУ, Строки.СуммаНУ) КАК СуммаНУДт,
	|	ЕСТЬNULL(Стоимости.СуммаПР, Строки.СуммаПР) КАК СуммаПРДт,
	|	ЕСТЬNULL(Стоимости.СуммаВР, Строки.СуммаВР) КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Производство) КАК ВидСчетаКт,
	|	ЕСТЬNULL(Стоимости.ГруппаПродукции, Строки.ГруппаПродукции) КАК АналитикаУчетаКт,
	|	Строки.ПодразделениеАналитики КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Строки.ПодразделениеАналитики КАК ПодразделениеКт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	Строки.Номенклатура КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.МатериальныеЗатраты) КАК СубконтоКт2,
	|	ЕСТЬNULL(Стоимости.ГруппаПродукции, Строки.ГруппаПродукции) КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	ЕСТЬNULL(Стоимости.СуммаНУ, Строки.СуммаНУ) КАК СуммаНУКт,
	|	ЕСТЬNULL(Стоимости.СуммаПР, Строки.СуммаПР) КАК СуммаПРКт,
	|	ЕСТЬNULL(Стоимости.СуммаВР, Строки.СуммаВР) КАК СуммаВРКт,
	|	""Себестоимость реализованного товара"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РеализацияТоваровУслуг КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСтроки КАК Строки
	|	ПО
	|		Операция.Ссылка = Строки.Ссылка
	|		И Строки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтСтоимости КАК Стоимости
	|	ПО
	|		Строки.Ссылка = Стоимости.Ссылка
	|		И Строки.Номенклатура = Стоимости.Номенклатура
	|		И Строки.Склад = Стоимости.Склад
	|		И Строки.ГруппаФинансовогоУчета = Стоимости.ГруппаФинансовогоУчета
	|		И Строки.НаправлениеДеятельности = Стоимости.НаправлениеДеятельности
	|		И Строки.РазделУчета = Стоимости.РазделУчета
	|		И Строки.НастройкаХозяйственнойОперации = Стоимости.НастройкаХозяйственнойОперации
	|		И Строки.ИдентификаторФинЗаписи = Стоимости.ИдентификаторФинЗаписи
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РаздельныйУчет_НастройкиНалогообложенияПрибыли КАК ТаблицаНалогообложенияПрибыли
	|	ПО
	|		ТаблицаНалогообложенияПрибыли.Период = Операция.Дата
	|		И ТаблицаНалогообложенияПрибыли.Организация = Операция.Организация
	|		И ТаблицаНалогообложенияПрибыли.Подразделение = Операция.Подразделение
	|		И ТаблицаНалогообложенияПрибыли.ОбъектУчета = Строки.Номенклатура
	|		И ТаблицаНалогообложенияПрибыли.НаправлениеДеятельности = Операция.НаправлениеДеятельности
	|ГДЕ
	|	Операция.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.КПредоплате)
	|	И Строки.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|	И Строки.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)
	|	И Операция.ХозяйственнаяОперация В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиентуРеглУчет))
	|	И (
	|		ВЫБОР КОГДА Операция.ВернутьМногооборотнуюТару ТОГДА
	|			Строки.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ИНАЧЕ
	|			ИСТИНА
	|		КОНЕЦ)
	|";
	ТекстыЗапроса.Добавить(ТекстЗапроса);
#КонецОбласти

	Возврат СтрСоединить(ТекстыЗапроса, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());

КонецФункции

&ИзменениеИКонтроль("ТекстВыручкаОтРеализацииСобственногоТовара")
Функция RA_AdditionalFieldsТекстВыручкаОтРеализацииСобственногоТовара()

	ТекстВыручкаОтРеализацииСобственногоТовара = "
	|ВЫБРАТЬ //// Выручка от реализации собственного товара (Дт 62.01 :: Кт 90.01.1)
	|	Операция.Ссылка КАК Ссылка,
	|	ВЫБОР КОГДА Операция.ХозяйственнаяОперация В
	|				(ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности),
	|				 ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности))
	|		ТОГДА Операция.ДатаПереходаПраваСобственности
	|		ИНАЧЕ Операция.Дата
	|	КОНЕЦ КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(Суммы.СуммаБезНДСРегл + Суммы.СуммаНДСРегл, Строки.СуммаСНДС) КАК Сумма,
	|	ЕСТЬNULL(Суммы.СуммаБезНДСУпр + Суммы.СуммаНДСУпр, Строки.СуммаСНДС / КурсВалютыУпрУчета.Курс) КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.РасчетыСКлиентами) КАК ВидСчетаДт,
	|	ЕСТЬNULL(РасчетыПоЗаказам.ГруппаФинансовогоУчета, Расчеты.ГруппаФинансовогоУчета) КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Операция.ВалютаВзаиморасчетов КАК ВалютаДт,
	|	ЕСТЬNULL(РасчетыПоЗаказам.Подразделение, Расчеты.Подразделение) КАК ПодразделениеДт,
	|	ЕСТЬNULL(РасчетыПоЗаказам.НаправлениеДеятельности, Расчеты.НаправлениеДеятельности) КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	ЕСТЬNULL(РасчетыПоЗаказам.Контрагент, Расчеты.Контрагент) КАК СубконтоДт1,
	|	ЕСТЬNULL(РасчетыПоЗаказам.Договор, Расчеты.Договор) КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	Строки.СуммаВзаиморасчетов КАК ВалютнаяСуммаДт,
	|	Строки.Количество КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	ВЫБОР
	|		КОГДА НЕ ТаблицаНалогообложенияПрибыли.Организация ЕСТЬ NULL
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ВыручкаРаздельныйНУ)
	|		КОГДА Операция.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД)
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ВыручкаОтПродажЕНВД)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ВыручкаОтПродаж)
	|	КОНЕЦ КАК ВидСчетаКт,
	|	ВЫБОР КОГДА &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета ТОГДА
	|		Строки.ВидЗапасов.ГруппаФинансовогоУчета
	|	ИНАЧЕ
	|		Строки.АналитикаУчетаНоменклатуры.Номенклатура.ГруппаФинансовогоУчета
	|	КОНЕЦ КАК АналитикаУчетаКт,
	|	ВЫБОР
	|		КОГДА Операция.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера),
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности))
	|		ТОГДА ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|		ИНАЧЕ Строки.АналитикаУчетаНоменклатуры.МестоХранения
	|	КОНЕЦ КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	#Удаление
	|	Операция.Подразделение КАК ПодразделениеКт,
	#КонецУдаления
	#Вставка
	|	Строки.АналитикаУчетаНоменклатуры.Номенклатура.RA_AdditionalFields_ProfitCentre КАК ПодразделениеКт,
	#КонецВставки
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	Строки.АналитикаУчетаНоменклатуры.Номенклатура КАК СубконтоКт1,
	|	Строки.СтавкаНДС.ПеречислениеСтавкаНДС КАК СубконтоКт2,
	|	ЕСТЬNULL(ТаблицаНалогообложенияПрибыли.ВариантНалогообложенияПрибыли, Строки.АналитикаУчетаНоменклатуры.Номенклатура) КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	Строки.Количество КАК КоличествоКт,
	|	ЕСТЬNULL(Суммы.СуммаБезНДСРегл, Строки.СуммаСНДС - Строки.СуммаНДС) КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Выручка от реализации собственного товара"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РеализацияТоваровУслуг КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РеализацияТоваровУслуг.ВидыЗапасов КАК Строки
	|	ПО
	|		(Строки.Ссылка = Операция.Ссылка)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютахУчета КАК Суммы
	|	ПО
	|		Строки.Ссылка = Суммы.Регистратор
	|		И Строки.ИдентификаторСтроки = Суммы.ИдентификаторСтроки
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВТРасчетыСКлиентамиПоЗаказам КАК РасчетыПоЗаказам
	|	ПО
	|		Операция.Ссылка = РасчетыПоЗаказам.Ссылка
	|		И Строки.ЗаказКлиента = РасчетыПоЗаказам.Заказ
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВТРасчетыСКлиентамиПоЗаказам КАК Расчеты
	|	ПО
	|		Операция.Ссылка = Расчеты.Ссылка
	|		И Расчеты.Заказ = НЕОПРЕДЕЛЕНО
	|		И Расчеты.СуммаРегл <> 0
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсВалютыУпрУчета
	|	ПО
	|		КурсВалютыУпрУчета.Валюта = &ВалютаУпрУчета
	|		И КурсВалютыУпрУчета.Дата = ВЫБОР КОГДА Операция.ХозяйственнаяОперация В
	|			(ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности),
	|			 ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности))
	|			ТОГДА Операция.ДатаПереходаПраваСобственности ИНАЧЕ НАЧАЛОПЕРИОДА(Операция.Дата, День) КОНЕЦ
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РаздельныйУчет_НастройкиНалогообложенияПрибыли КАК ТаблицаНалогообложенияПрибыли
	|	ПО
	|		ТаблицаНалогообложенияПрибыли.Период = ВЫБОР КОГДА Операция.ХозяйственнаяОперация =
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности) ТОГДА
	|			Операция.ДатаПереходаПраваСобственности ИНАЧЕ Операция.Дата КОНЕЦ
	|		И ТаблицаНалогообложенияПрибыли.Организация = Операция.Организация
	|		И ТаблицаНалогообложенияПрибыли.Подразделение = Операция.Подразделение
	|		И ТаблицаНалогообложенияПрибыли.ОбъектУчета = Строки.АналитикаУчетаНоменклатуры.Номенклатура
	|		И ТаблицаНалогообложенияПрибыли.НаправлениеДеятельности = Операция.НаправлениеДеятельности
	|
	|ГДЕ
	|	Строки.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|	И (Операция.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту),
	|										 ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера))
	|			И Операция.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.КПредоплате)
	|		ИЛИ Операция.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиентуРеглУчет)
	|			И Операция.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.КПредоплате)
	|		ИЛИ Операция.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности),
	|											  ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионераБезПереходаПраваСобственности))
	|			И Операция.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.Отгружено))
	|	И (
	|		ВЫБОР КОГДА Операция.ВернутьМногооборотнуюТару ТОГДА
	|			Строки.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ИНАЧЕ
	|			ИСТИНА
	|		КОНЕЦ)
	|";
	Возврат ТекстВыручкаОтРеализацииСобственногоТовара;

КонецФункции

&ИзменениеИКонтроль("ТекстНДССРеализации")
	Функция RA_AdditionalFieldsТекстНДССРеализации()

	ТекстНДССРеализации = "
	|ВЫБРАТЬ  //// НДС с реализации (Дт 90.03 :: Кт 68.02)
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(Суммы.СуммаНДСРегл, Строки.СуммаНДС) КАК Сумма,
	|	ЕСТЬNULL(Суммы.СуммаНДСУпр, Строки.СуммаНДС / КурсВалютыУпрУчета.Курс) КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.НДСПриПродаже) КАК ВидСчетаДт,
	|	ВЫБОР КОГДА &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета ТОГДА
	|		Строки.ВидЗапасов.ГруппаФинансовогоУчета
	|	ИНАЧЕ
	|		Строки.АналитикаУчетаНоменклатуры.Номенклатура.ГруппаФинансовогоУчета
	|	КОНЕЦ КАК АналитикаУчетаДт,
	|	ВЫБОР
	|		КОГДА Операция.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера)
	|		ТОГДА ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|		ИНАЧЕ Строки.АналитикаУчетаНоменклатуры.МестоХранения
	|	КОНЕЦ КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	#Удаление
	|	Операция.Подразделение КАК ПодразделениеДт,
	#КонецУдаления
	#Вставка
	|	Строки.АналитикаУчетаНоменклатуры.Номенклатура.RA_AdditionalFields_ProfitCentre КАК ПодразделениеДт,
	#КонецВставки
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	Строки.АналитикаУчетаНоменклатуры.Номенклатура КАК СубконтоДт1,
	|	Строки.СтавкаНДС.ПеречислениеСтавкаНДС КАК СубконтоДт2,
	|	ЕСТЬNULL(ТаблицаНалогообложенияПрибыли.ВариантНалогообложенияПрибыли, НЕОПРЕДЕЛЕНО) КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	Строки.Количество КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	&ВалютаРеглУчета КАК ВалютаКт,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК ПодразделениеКт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС) КАК СчетКт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейВГосБюджет.Налог) КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	ЕСТЬNULL(Суммы.СуммаНДСРегл, Строки.СуммаНДС) КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""НДС с реализации"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РеализацияТоваровУслуг КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РеализацияТоваровУслуг.ВидыЗапасов КАК Строки
	|	ПО
	|		(Строки.Ссылка = Операция.Ссылка)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютахУчета КАК Суммы
	|	ПО
	|		Строки.Ссылка = Суммы.Регистратор
	|		И Строки.ИдентификаторСтроки = Суммы.ИдентификаторСтроки
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсВалютыУпрУчета
	|	ПО
	|		КурсВалютыУпрУчета.Валюта = &ВалютаУпрУчета
	|		И КурсВалютыУпрУчета.Дата = НАЧАЛОПЕРИОДА(Операция.Дата, День)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РаздельныйУчет_НастройкиНалогообложенияПрибыли КАК ТаблицаНалогообложенияПрибыли
	|	ПО
	|		ТаблицаНалогообложенияПрибыли.Период = Операция.Дата
	|		И ТаблицаНалогообложенияПрибыли.Организация = Операция.Организация
	|		И ТаблицаНалогообложенияПрибыли.Подразделение = Операция.Подразделение
	|		И ТаблицаНалогообложенияПрибыли.ОбъектУчета = Строки.АналитикаУчетаНоменклатуры.Номенклатура
	|		И ТаблицаНалогообложенияПрибыли.НаправлениеДеятельности = Операция.НаправлениеДеятельности
	|
	|ГДЕ
	|	Операция.НалогообложениеНДС В (
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС),
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПроизводствоСДЦ))
	|	И Строки.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|	И Операция.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.КПредоплате)
	|	И Операция.ХозяйственнаяОперация В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиентуРеглУчет),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияЧерезКомиссионера))
	|	И (
	|		ВЫБОР КОГДА Операция.ВернутьМногооборотнуюТару ТОГДА
	|			Строки.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ИНАЧЕ
	|			ИСТИНА
	|		КОНЕЦ)
	|";
	Возврат ТекстНДССРеализации;

КонецФункции

#КонецОбласти