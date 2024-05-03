#Область ОбработчикиСобытийФормы

&НаСервере
Процедура RA_AdditionalFieldsПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	RA_AdditionalFields_ДобавитьЭлементыНаФорму();	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура RA_AdditionalFields_ДобавитьЭлементыНаФорму()
	
	//Добавим группу Bayer
	ГруппаBayer = Элементы.Вставить("РА_ГруппаBayer", Тип("ГруппаФормы"), Элементы.ГруппаОбщаяИнформация,
		Элементы.ГруппаОтношенияДополнительно);
	ГруппаBayer.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	//@skip-check bsl-legacy-check-expression-type
	ГруппаBayer.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаBayer.ОтображатьЗаголовок = Истина;
	ГруппаBayer.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаBayer.Заголовок = "Bayer";
	//@skip-check bsl-legacy-check-expression-type
	ГруппаBayer.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	ГруппаBayer.Поведение = ПоведениеОбычнойГруппы.Свертываемая; 
	ГруппаBayer.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
	ГруппаBayer.Скрыть();

	НовыйЭлемент = Элементы.Добавить("RA_КодSAP", Тип("ПолеФормы"), ГруппаBayer);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.RA_AdditionalFields_КодSAP";
	НовыйЭлемент.Ширина = 28;
	НовыйЭлемент.АвтоМаксимальнаяШирина = Ложь;
	НовыйЭлемент.МаксимальнаяШирина = 28;

	НовыйЭлемент = Элементы.Добавить("RA_TradingPartner", Тип("ПолеФормы"), ГруппаBayer);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.RA_AdditionalFields_TradingPartner";
	НовыйЭлемент.Ширина = 28;
	НовыйЭлемент.АвтоМаксимальнаяШирина = Ложь;
	НовыйЭлемент.МаксимальнаяШирина = 28;
	
	НовыйЭлемент = Элементы.Добавить("RA_SearchTerm", Тип("ПолеФормы"), ГруппаBayer);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.RA_AdditionalFields_SearchTerm";
	НовыйЭлемент.Ширина = 28;
	НовыйЭлемент.АвтоМаксимальнаяШирина = Ложь;
	НовыйЭлемент.МаксимальнаяШирина = 28;
	
	НовыйЭлемент = Элементы.Добавить("RA__Region", Тип("ПолеФормы"), ГруппаBayer);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.RA_AdditionalFields_Region";
	НовыйЭлемент.Ширина = 28;
	НовыйЭлемент.АвтоМаксимальнаяШирина = Ложь;
	НовыйЭлемент.МаксимальнаяШирина = 28;

	Страница_Грузополучатели = Элементы.Добавить("RA_Страница_Грузополучатели", Тип("ГруппаФормы"), Элементы.ГруппаСтраницы);
	Страница_Грузополучатели.Вид = ВидГруппыФормы.Страница;
	Страница_Грузополучатели.Заголовок = "Грузополучатели";
	Страница_Грузополучатели.ПутьКДаннымЗаголовка = "Объект.RA_AdditionalFields_СписокГрузополучателей.КоличествоСтрок";
	
	RA_Таблица_Грузополучатели = Элементы.Добавить("RA_Таблица_Грузополучатели", Тип("ТаблицаФормы"), Страница_Грузополучатели);
	RA_Таблица_Грузополучатели.ПутьКДанным = "Объект.RA_AdditionalFields_СписокГрузополучателей";
	
	НовыйЭлемент  = Элементы.Добавить("RA_Таблица_Грузополучатели_Грузополучатель", Тип("ПолеФормы"), RA_Таблица_Грузополучатели);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.RA_AdditionalFields_СписокГрузополучателей.Грузополучатель";
	
КонецПроцедуры

#КонецОбласти