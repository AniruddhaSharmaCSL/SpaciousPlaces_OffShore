using UnityEngine;

namespace SpaciousPlaces
{
    public class ShowIfAttribute : PropertyAttribute
    {
        public string[] ConditionMethods { get; private set; }
        public LogicOperator LogicOp { get; private set; }

        public ShowIfAttribute(string conditionMethod)
        {
            ConditionMethods = new[] { conditionMethod };
            LogicOp = LogicOperator.Or;
        }

        public ShowIfAttribute(string[] conditionMethods, LogicOperator logicOperator = LogicOperator.Or)
        {
            ConditionMethods = conditionMethods;
            LogicOp = logicOperator;
        }
    }

    public enum LogicOperator
    {
        And,
        Or
    }
}