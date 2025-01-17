
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
	ГруппаBayer = Элементы.Добавить("РА_ГруппаBayer", Тип("ГруппаФормы"), Элементы.ГруппаШапкаГоризонтальная);
	ГруппаBayer.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	//@skip-check wrong-type-expression
	ГруппаBayer.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаBayer.ОтображатьЗаголовок = Истина;
	ГруппаBayer.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаBayer.Заголовок = "BAYER";
	//@skip-check wrong-type-expression
	ГруппаBayer.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	
	НовыйЭлемент = Элементы.Добавить("RA_КодSAP", Тип("ПолеФормы"), ГруппаBayer);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.RA_AdditionalFields_КодSAP";
	
	НовыйЭлемент = Элементы.Добавить("RA_ProfitCenter", Тип("ПолеФормы"), ГруппаBayer);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.RA_AdditionalFields_ГФУ_ProfitCenter";
	
КонецПроцедуры

#КонецОбласти

