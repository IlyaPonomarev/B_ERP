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
	ГруппаBayer = Элементы.Добавить("РА_ГруппаBayer", Тип("ГруппаФормы"), Элементы.ГруппаДанныеШапки);
	ГруппаBayer.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	//@skip-check wrong-type-expression
	ГруппаBayer.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаBayer.ОтображатьЗаголовок = Истина;
	ГруппаBayer.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаBayer.Заголовок = "BAYER";
	ГруппаBayer.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;

	НовыйЭлемент = Элементы.Добавить("RA_Division", Тип("ПолеФормы"), ГруппаBayer);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.RA_AdditionalFields_Division";
	
	НовыйЭлемент = Элементы.Добавить("RA_ItsSalesPurchasingOrganization", Тип("ПолеФормы"), ГруппаBayer);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
	НовыйЭлемент.ПутьКДанным = "Объект.RA_AdditionalFields_ItsSalesPurchasingOrganization";
	
КонецПроцедуры

#КонецОбласти