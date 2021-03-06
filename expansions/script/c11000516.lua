--Shya Messenger
function c11000516.initial_effect(c)
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--destroy set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11000516,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11000516)
	e2:SetCondition(c11000516.condition)
	e2:SetTarget(c11000516.target)
	e2:SetOperation(c11000516.operation)
	c:RegisterEffect(e2)
end
function c11000516.condition(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x1FD)) or
		((re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL) or
		re:IsActiveType(TYPE_TRAP)) and re:GetHandler():IsSetCard(0x1FD) 
		and bit.band(r,REASON_EFFECT)~=0)
end
function c11000516.filter(c)
  return c:IsPosition(POS_FACEDOWN) and c:IsDestructable()
end
function c11000516.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c11000516.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11000516.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11000516.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c11000516.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end