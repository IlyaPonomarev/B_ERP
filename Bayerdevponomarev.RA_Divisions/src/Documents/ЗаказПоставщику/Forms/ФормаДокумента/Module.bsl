#Область ОбработчикиСобытийФормы

&НаСервере
Процедура RA_AdditionalFieldsПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	RA_AdditionalFields_МодификацияФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура RA_AdditionalFieldsТоварыСписатьНаРасходыПриИзмененииПосле(Элемент)
		
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	
	Если НЕ ТекДанные.СписатьНаРасходы Тогда
		Возврат;
	КонецЕсли;
		
	ТекДанные.Подразделение = ТекДанные.RA_AdditionalFields_CostCentre;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура RA_AdditionalFields_МодификацияФормы()
	
	// Настроим параметры выбора и предсставлене поля "Менеджер"
	RA_AdditionalFields_ИзменениеИнтерфейсаФорм.НастроитьПолеМенеджерНаФормеДокумента(ЭтотОбъект, Истина);

	НовыйЭлемент = Элементы.Добавить("RA_CostCentre", Тип("ПолеФормы"), Элементы.Товары);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.Товары.RA_AdditionalFields_CostCentre";

	//@skip-check bsl-legacy-check-static-feature-access-for-unknown-left-part
	НовыйЭлемент.ПараметрыВыбора = Новый ФиксированныйМассив(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		Новый ПараметрВыбора("Отбор.RA_AdditionalFields_ItsCostCentre", Истина)));
		
	НовыйЭлемент.УстановитьДействие("ПриИзменении", "RA_AdditionalFields_Подключаемый_RA_CostCentreПриИзменении");	
	
	
	НовыйЭлемент = Элементы.Добавить("RA_Requisitioner", Тип("ПолеФормы"), Элементы.ШапкаЛево);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "Объект.RA_AdditionalFields_Requisitioner";
	НовыйЭлемент.МаксимальнаяШирина = 28;
	НовыйЭлемент.АвтоМаксимальнаяШирина = Ложь;
		
КонецПроцедуры

&НаКлиенте
Процедура RA_AdditionalFields_Подключаемый_RA_CostCentreПриИзменении(Элемент)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;

	Если Не ТекДанные.СписатьНаРасходы Тогда
		Возврат;
	КонецЕсли;

	Если ТекДанные.СписатьНаРасходы Тогда
		ТекДанные.Подразделение = ТекДанные.RA_AdditionalFields_CostCentre;
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти