#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступныеВиджеты = ТекущиеДелаEDI.ВсеВиджетыДоступныеПоПравам();
	ВиджетыДляВыбора = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДоступныеВиджеты, Параметры.ИспользуемыеВиджеты.ВыгрузитьЗначения());
	
	Для Каждого Виджет Из ВиджетыДляВыбора Цикл
		
		НоваяСтрока = Виджеты.Добавить();
		НоваяСтрока.Виджет = Виджет;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВиджетыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьВиджет();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьВиджет();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИфФункции

&НаКлиенте
Процедура ВыбратьВиджет()
	
	ТекущиеДанные = Элементы.Виджеты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(ПараметрыЗакрытия(ТекущиеДанные.Виджет));
	
КонецПроцедуры

&НаСервере
Функция ПараметрыЗакрытия(Виджет)
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ВыбранныйВиджет",Виджет);
	ПараметрыЗакрытия.Вставить("ВыбранныеРазделы", ТекущиеДелаEDI.РазделыПоУмолчанию(Виджет));
	
	Возврат ПараметрыЗакрытия;
	
КонецФункции

#КонецОбласти


