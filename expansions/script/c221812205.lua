--Viravolve Doom
function c221812205.initial_effect(c)
	--If this card is Special Summoned: Place 1 Doom Counter on it.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetTarget(c221812205.addct)
	e1:SetOperation(c221812205.addc)
	c:RegisterEffect(e1)
	--If this card would be destroyed by battle, you can remove 1 Doom Counter from this card instead, and if you do, destroy your opponent's battling monster.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c221812205.desreptg)
	e4:SetOperation(c221812205.desrepop)
	c:RegisterEffect(e4)
	--If this card was used for the Xyz Summon of a Cyberse Xyz Monster, you can place 1 Doom Counter on that monster, also it gains the following effect. (below)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c221812205.efcon)
	e5:SetOperation(c221812205.efop)
	c:RegisterEffect(e5)
	--If this card is sent from the field to the GY, or detached from an Xyz Monster, inflict 200 damage to your opponent.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c221812205.thcon)
	e2:SetOperation(c221812205.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(function(e) local c=e:GetHandler() return c:IsPreviousLocation(LOCATION_OVERLAY) and not c:IsReason(REASON_RULE) end)
	c:RegisterEffect(e3)
end
function c221812205.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1c8c)
end
function c221812205.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1c8c+COUNTER_NEED_ENABLE,1)
	end
end
function c221812205.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE) and c:GetCounter(0x1c8c)>0 end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else return false end
end
function c221812205.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveCounter(tp,0x1c8c,1,REASON_EFFECT)
	Duel.Destroy(c:GetBattleTarget(),REASON_EFFECT)
end
function c221812205.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsRace(RACE_CYBERS)
end
function c221812205.efop(e,tp,eg,ep,ev,re,r,rp)
	--if not Duel.SelectYesNo(tp,aux.Stringid(221812205,0)) then return end
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--If this card would be destroyed by battle while it has "Viravolve Doom" as a material, remove 1 Doom Counter from it and destroy the monster battling this card instead.
	if rc:GetFlagEffect(221812205)~=0 then return end
	rc:AddCounter(0x1c8c,1)
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(221812205,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetTarget(c221812205.reptg)
	e1:SetOperation(c221812205.repop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	rc:RegisterFlagEffect(221812205,RESET_EVENT+0x1fe0000,0,0)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c221812205.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,221812205) and c:IsReason(REASON_BATTLE) and c:GetCounter(0x1c8c)>0 end
	return true
end
function c221812205.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	c:RemoveCounter(tp,0x1c8c,1,REASON_EFFECT)
	Duel.Destroy(c:GetBattleTarget(),REASON_EFFECT)
end
function c221812205.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetPreviousLocation()
	return (bit.band and bit.band(loc,LOCATION_ONFIELD)~=0) or loc&LOCATION_ONFIELD~=0 or (loc==LOCATION_OVERLAY and not c:IsReason(REASON_RULE))
end
function c221812205.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,221812205)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
