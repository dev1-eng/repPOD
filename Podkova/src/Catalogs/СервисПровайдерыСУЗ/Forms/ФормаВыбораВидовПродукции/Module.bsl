#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.АвтоЗаголовок = Ложь;
	
	ШаблонЗаголовок = НСтр("ru = '%1 (виды продукции)'");
	
	Если Параметры.Ссылка.Пустая() Тогда
		ЭтотОбъект.Заголовок = СтрШаблон(ШаблонЗаголовок, НСтр("ru = 'Сервис-провайдер СУЗ (создание)'"));
	Иначе
		ЭтотОбъект.Заголовок = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Ссылка, "Наименование") +
			СтрШаблон(ШаблонЗаголовок, НСтр("ru = ' (Сервис-провайдер СУЗ)'"));
	КонецЕсли;
		
	ВыбранныеВидыПродукции.ЗагрузитьЗначения(Параметры.ВыбранныеВидыПродукции);
	ЗаполнитьПредставленияЗначенийСписка(ВыбранныеВидыПродукции);
	ВыбранныеВидыПродукции.СортироватьПоПредставлению();
	
	ЗаполнитьДоступныеВидыПродукции();
	ЗаполнитьПредставленияЗначенийСписка(ДоступныеВидыПродукции);
	ДоступныеВидыПродукции.СортироватьПоПредставлению();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДоступныеВидыПродукцииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПереместитьЭлемент(Элементы.ДоступныеВидыПродукции.Имя, Элементы.ВыбранныеВидыПродукции.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеВидыПродукцииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПереместитьЭлемент(Элементы.ВыбранныеВидыПродукции.Имя, Элементы.ДоступныеВидыПродукции.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьЭлемент(Команда)
	
	ПереместитьЭлемент(Элементы.ДоступныеВидыПродукции.Имя, Элементы.ВыбранныеВидыПродукции.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВсеЭлементы(Команда)
	
	ПереместитьВсеЭлементы(Элементы.ДоступныеВидыПродукции.Имя, Элементы.ВыбранныеВидыПродукции.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЭлемент(Команда)
	
	ПереместитьЭлемент(Элементы.ВыбранныеВидыПродукции.Имя, Элементы.ДоступныеВидыПродукции.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсеЭлементы(Команда)
	
	ПереместитьВсеЭлементы(Элементы.ВыбранныеВидыПродукции.Имя, Элементы.ДоступныеВидыПродукции.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	Закрыть(ВыбранныеВидыПродукции.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДоступныеВидыПродукции()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВыбранныеВидыПродукции", ВыбранныеВидыПродукции);
	Запрос.УстановитьПараметр("НеДоступныеВидыПродукции", ПолучитьНеДоступныеВидыПродукции());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиУчетаМаркируемойПродукции.ВидПродукции КАК ВидПродукции
	|ИЗ
	|	РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП КАК НастройкиУчетаМаркируемойПродукции
	|ГДЕ
	|	НастройкиУчетаМаркируемойПродукции.ВестиУчетПродукции
	|	И НЕ НастройкиУчетаМаркируемойПродукции.ВидПродукции В (&ВыбранныеВидыПродукции)
	|	И НЕ НастройкиУчетаМаркируемойПродукции.ВидПродукции В (&НеДоступныеВидыПродукции)";
	
	ДоступныеВидыПродукции.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидПродукции"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьНеДоступныеВидыПродукции()
	
	Результат = Новый Массив;
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак"));
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПредставленияЗначенийСписка(Список)
	
	Для Каждого Элемент Из Список Цикл
		Элемент.Представление = Строка(Элемент.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлемент(ИмяИсточника, ИмяПриемника)
	
	ТекущиеДанные = Элементы[ИмяИсточника].ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ИмяПриемника].Добавить(ТекущиеДанные.Значение, ТекущиеДанные.Представление);
	
	ЭтотОбъект[ИмяПриемника].СортироватьПоПредставлению();
	
	ЭтотОбъект[ИмяИсточника].Удалить(ЭтотОбъект[ИмяИсточника].НайтиПоИдентификатору(Элементы[ИмяИсточника].ТекущаяСтрока));
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВсеЭлементы(ИмяИсточника, ИмяПриемника)
	
	Если ЭтотОбъект[ИмяИсточника].Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из ЭтотОбъект[ИмяИсточника] Цикл
		ЭтотОбъект[ИмяПриемника].Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;
	
	ЭтотОбъект[ИмяПриемника].СортироватьПоПредставлению();
	
	ЭтотОбъект[ИмяИсточника].Очистить();
	
КонецПроцедуры

#КонецОбласти
