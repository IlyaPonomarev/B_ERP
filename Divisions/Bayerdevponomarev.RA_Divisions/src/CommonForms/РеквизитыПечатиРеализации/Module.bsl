
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура RA_AdditionalFieldsПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	RA_AdditionalFields_ИзменитьФорму();	

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура RA_AdditionalFields_ИзменитьФорму()
	RA_AdditionalFields_ИзменитьПолеГрузополучателя();
КонецПроцедуры

&НаСервере
Процедура RA_AdditionalFields_ИзменитьПолеГрузополучателя()

	Если Не RA_AdditionalFields_ИспользоватьОтборПоГрузополучателю() Тогда
		Возврат;
	КонецЕсли;

	Элементы.Грузополучатель.УстановитьДействие("НачалоВыбора",
		"RA_AdditionalFields_ПодключаемыйГрузополучательНачалоВыбора");

	Элементы.Грузополучатель.РедактированиеТекста = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура RA_AdditionalFields_ПодключаемыйГрузополучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СписокГрузополучателей = RA_AdditionalFields_ПолучитьСписокЗначенийГрузополучателей(Партнер);
	
	Если НЕ СписокГрузополучателей.Количество() Тогда
		Возврат;
	КонецЕсли;	

	СтандартнаяОбработка = Ложь;

	НастройкиКД = Новый НастройкиКомпоновкиДанных;

	Отбор = НастройкиКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Ссылка");
	Отбор.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
	Отбор.ПравоеЗначение   = СписокГрузополучателей;
	Отбор.Использование    = Истина;
	Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
   
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ФиксированныеНастройки", НастройкиКД);

	//ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаВыбораИспользуютсяТолькоПартнерыБезПолнотекстовогоПоиска", ПараметрыФормы, Элемент);

КонецПроцедуры

&НаСервереБезКонтекста
Функция RA_AdditionalFields_ПолучитьСписокЗначенийГрузополучателей(Партнер)

	УстановитьПривилегированныйРежим(Истина);

	СписокЗначенийДляОтбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПартнерыRA_AdditionalFields_СписокГрузополучателей.Грузополучатель КАК Грузополучатель
		|ИЗ
		|	Справочник.Партнеры.RA_AdditionalFields_СписокГрузополучателей КАК ПартнерыRA_AdditionalFields_СписокГрузополучателей
		|ГДЕ
		|	ПартнерыRA_AdditionalFields_СписокГрузополучателей.Ссылка = &Ссылка
		|СГРУППИРОВАТЬ ПО
		|	ПартнерыRA_AdditionalFields_СписокГрузополучателей.Грузополучатель";
	
	Запрос.УстановитьПараметр("Ссылка", Партнер);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СписокЗначенийДляОтбора.Добавить(ВыборкаДетальныеЗаписи.Грузополучатель);
	КонецЦикла;
		
	Возврат СписокЗначенийДляОтбора;

КонецФункции

&НаСервереБезКонтекста
Функция RA_AdditionalFields_ИспользоватьОтборПоГрузополучателю()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.RA_AdditionalFields_ИспользоватьОтборГрузополучателяПоПартнеру.Получить();

КонецФункции

#КонецОбласти